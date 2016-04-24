//
//  Detail_Model.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import ChameleonFramework
import Alamofire


class Detail_Model: ViewModel, UITableViewDataSource, UITableViewDelegate, ListsAPIObjects {
  // MARK: -- variables
  var loadingWheel: UIActivityIndicatorView?
  
  var name: JSON? ; var type: JSON? ; var weight: JSON?
  var sprite: UIImage?
  var sprites: JSON?
  
  var tableDataList = [tableViewJSONObj]() {
    didSet {
      self.reloadTableView()
    }
  }
  
  var focus: JSON?

  
  // MARK: -- Alamofire functions
  func executeGetRequest(url: String) {
    SAFECAST(master, type: DetailViewController.self) { master in
      self.loadingWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
      SAFE(self.loadingWheel) { loadingWheel in
        master.view.addSubview(loadingWheel)
        loadingWheel.center = master.view.center
        loadingWheel.startAnimating()
      }
      Alamofire.request(.GET, url).responseJSON { response in
        SAFE(response.result.value) { response in
          self.extractJSON(JSON(response))
          SAFE(self.loadingWheel) { $0.stopAnimating() ; $0.removeFromSuperview() }
        }
      }
    }
  }
  
  func setLabels() {  // what a waste of space
    SAFECAST(master, type: DetailViewController.self) { master in
//      print(String(self.name))
      
      master.lblName.text = self.name?.stringValue ; master.lblType.text = self.type?.stringValue
      master.lblWeight.text = "\(self.weight!.stringValue)kg"
    	}
  }
  
  func setImage() {
    SAFECAST(master, type: DetailViewController.self) { master in
      SAFECAST(master.imgSprite, type: CarouselImageView.self) { image in
        var out: [UIImage] = [image.image!]   //   assuming it has an image
        SAFE(self.sprites) { sprites in
          var urlArray = [JSON]()
          for (key, value) in sprites {
            if value != nil { urlArray.append(value) }
          }
          image.expectedSpriteCount = urlArray.count       //    allows "finished downloading" condition
          let NSUrlArray = urlArray.map( { NSURL(string: $0.stringValue)! })
          image.downloadSprites(NSUrlArray)

        }
        }
    }
  }
  
  func extractJSON(obj: JSON) {
    self.name = obj["name"]  ;  self.weight = obj["weight"]
    self.type = obj["types"][0]["type"]["name"]
    self.sprites = obj["sprites"]
    setColors(self.type!)
    setLabels() ; setImage()
    var out: [tableViewJSONObj] = [(JSON("moveBlock"), JSON(""))]
    if let moves = obj["moves"].array {
      moves.map { move in
       out.append((JSON("move"), move))
      }
    }
    

    self.tableDataList = out
    
    
  }
  
  
  // MARK: -- custom functions
  func setColors(type: JSON) {
    print(type)
    SAFECAST(master, type: DetailViewController.self) { master in
      SAFE(type.string) { type in
        switch type {
          case "fire":
            master.mainColor = UIColor.flatRedColor()
            master.secondaryColor = UIColor.flatRedColorDark()
          case "grass", "poison":
            master.mainColor = UIColor.flatGreenColor()
            master.secondaryColor = UIColor.flatGreenColorDark()
          case "water":
            master.mainColor = UIColor.flatSkyBlueColor()
            master.secondaryColor = UIColor.flatSkyBlueColorDark()
          case "fighting", "flying":
            master.mainColor = UIColor.flatBrownColor()
            master.secondaryColor = UIColor.flatBrownColorDark()
          case "psychic":
            master.mainColor = UIColor.flatPurpleColor()
            master.secondaryColor = UIColor.flatPurpleColorDark()
          break
          default:
            master.mainColor = UIColor.flatGrayColor()
            master.secondaryColor = UIColor.flatGrayColorDark()
          break
        }
       master.tblDetails.backgroundColor = UIColor.flatBlackColorDark()
       master.navigationController?.navigationBar.tintColor = master.mainColor
      }
    }
  }
  
  func doWasCreated() {
    SAFECAST(master, type: DetailViewController.self) { master in
      master.tblDetails.backgroundColor = UIColor.flatBlackColor()
      master.navigationController?.navigationBar.barTintColor = UIColor.flatBlackColor()
      master.navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
    }
  }
  
  
  // MARK: -- tableView functions
  func reloadTableView() {
    SAFECAST(master, type: DetailViewController.self) { master in
//      print(self.tableDataList) 
      master.tblDetails.reloadData()
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableDataList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // InfoBlock or CustomCell
    
    var cell = CustomCell()
    if let master = self.master as? DetailViewController {
      cell = master.tblDetails.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
      var cellContents = tableDataList[indexPath.row]
      cell.backgroundColor = {indexPath.row % 2 == 0 ? master.mainColor : master.secondaryColor}()
      SAFE(cellContents.id?.stringValue) { id in
      switch id {
      case "name" :
        cell.textLabel!.text = cellContents.obj.string
        cell.backgroundColor = UIColor.flatBlackColor()
        cell.textLabel!.textColor = master.mainColor
      case "type":
        cell.textLabel!.text = "\(cellContents.obj.stringValue) type"
        cell.backgroundColor = UIColor.flatBlackColorDark()
        cell.textLabel!.textColor = master.secondaryColor
      case "weight" :
        cell.backgroundColor = UIColor.flatBlackColorDark()
        cell.textLabel!.textColor = master.mainColor
        let weight = String(cellContents.obj)
        cell.textLabel!.text = "weight: \(weight)kg"
      case "moveBlock":
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel!.textColor = master.secondaryColor
        cell.textLabel!.text = "moves"
      case "move":
        SAFE(cellContents.obj["move"]["name"].string) { moveName in
          cell.textLabel!.text = moveName
        }
      case "sprites":
        break
      default:
        break
      }
    }
    }
    cell.userInteractionEnabled = false
    return cell
  }

  
  
  // MARK: -- required functions
  init(master: DetailViewController) { super.init(_master: master) ; doWasCreated() }
  
} // end of model class