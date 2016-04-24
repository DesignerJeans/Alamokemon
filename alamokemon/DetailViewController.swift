//
//  DetailViewController.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

class DetailViewController: BetterViewController {
  // MARK: -- outlets
  @IBOutlet weak var tblDetails: UITableView!
  @IBOutlet weak var imgSprite: UIImageView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblType: UILabel!
  @IBOutlet weak var lblWeight: UILabel!
  
  
  
  
  // MARK: -- variables
  var focusURL: String?
  var mainColor: UIColor? ; var secondaryColor: UIColor?
  
  // MARK: -- custom functions
  func didLoadStuff() {
    model = Detail_Model(master: self)
    SAFECAST(model, type: Detail_Model.self) { model in
      self.tblDetails.dataSource = model ; self.tblDetails.delegate = model
      SAFE(self.focusURL) { focusURL in
        model.executeGetRequest(focusURL)
      }
    }
  }
  
  func willAppearStuff() {
    
  }
  
  func didAppearStuff() {
    
  }
  

  
  
  
  // MARK: -- required functions
  override func viewDidLoad() {
    super.viewDidLoad()
    didLoadStuff()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    didAppearStuff()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    willAppearStuff()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
} // end of class
