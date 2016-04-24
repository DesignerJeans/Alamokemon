//
//  CarouselImageView.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/23/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SwiftyJSON

let GLOBAL_FADE_TIME: CGFloat = 1.75
let GLOBAL_HOLD_TIME: CGFloat = GLOBAL_FADE_TIME * 3

class CarouselImageView: UIImageView {
  // MARK: -- variables
  var imageList: [UIImage]! {
    didSet {
        SAFE(self.expectedSpriteCount) { expectedSpriteCount in
          if self.imageList.count >= expectedSpriteCount {
            if self.animated == false { self.startCycle() }
          }
        }
    }
  }
  var animated: Bool = false
  
  var expectedSpriteCount: Int? {
    didSet { print ("Expected sprites \(expectedSpriteCount!)") }
  }
  
  
  // MARK: -- custom functions
  func pullImageInto(url: NSURL){
    getDataFromUrl(url) { (data, response, error)  in
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        guard let data = data where error == nil else { return }
        self.imageList.append(UIImage(data: data)!)
      }
      }
  }
  
  
  func downloadSprites(URLList: [NSURL]) {
    SAFE(self.image) { image in
      self.imageList = [UIImage]()  ; print("image list initialized with snorlax default")
      URLList.map { URL in
          self.pullImageInto(URL)
      }
    }
  }
  
  func startCycle() {
    self.animated = true
  
    animateThen(NSTimeInterval(GLOBAL_FADE_TIME), animations: { 
      self.alpha = 0
      }) { 
          self.advanceImage()
    }
  }
  
  func advanceImage() {  // assumes alpha is 0
    SAFE(self.imageList) { imageList in
      var tempArray = imageList
      tempArray.append(tempArray.removeFirst())
      self.imageList = tempArray
      self.image = self.imageList!.first
        animateThen(NSTimeInterval(GLOBAL_FADE_TIME), animations: {
          self.alpha = 1  // fade in
          }) {
            wait(2.0) {
              animateThen(NSTimeInterval(GLOBAL_FADE_TIME), animations: {
                self.alpha = 0
                }, completion: {
                  self.advanceImage()
              })
            }
        }
    }
  }
  
  
  // MARK: -- required functions
  
  
} // end of custom class

