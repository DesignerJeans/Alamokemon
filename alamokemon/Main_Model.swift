//
//  Main_Model.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ChameleonFramework
import SwiftyJSON

enum API_category: String {
  case pokemon = "pokemon"
  case ability = "ability"
  case type = "type"
}

let API_paths: [String: [String]] = [
 "speciesName": ["species", "name"]
]

// CONSTANTS
let MAX_ON_PAGE: Int = 45




class Main_Model: ViewModel, UITableViewDataSource, UITableViewDelegate, ListsAPIObjects {
  // MARK: -- variables
  var focus: JSON? {
    didSet { extractFromJSON() }
  }
  var category: API_category = .pokemon
  var loadingWheel: UIActivityIndicatorView?
  
  var tableDataList =  [tableViewJSONObj]() {
    didSet {
      self.reloadTableView()
    }
  }
  
  // MARK: -- custom functions
  func doWasCreated() {
    
    SAFECAST(master, type: MainViewController.self) { master in
//      self.reloadTableView()
      
    }
  }
  
  func traverseJSON(inout obj: JSON, path: [String]) -> JSON? {
    if path.count > 0 {
      var tempPath = path
      let thisPath = tempPath.removeFirst()
      return traverseJSON(&obj[thisPath], path: tempPath)
    }
    
    return obj
  }
  
  // MARK: -- alamoFire functions
  
  func getPageOf(category: API_category) {
    let startURL = self.createURL(category) + "?limit=\(MAX_ON_PAGE)"
    self.executeGetRequest(startURL)
  }
  func extractFromJSON() {
    PF("extractFromJSON")
    SAFE(focus) { focus in
      switch self.category {
      case .pokemon:
        let results = focus["results"].arrayValue
//        print(results)
        var outList = [tableViewJSONObj]()
        results.map { result in
          outList.append((result["url"], result["name"]))
        }
        self.tableDataList = outList
        
      case .ability:
        break
      case .type:
        break
      }
    }
  }
  
  
  func executeGetRequest(formattedURL: String, climberPath: [String]? = nil) {
    SAFECAST(master, type: MainViewController.self) { master in
      self.loadingWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
      SAFE(self.loadingWheel) { loadingWheel in
        master.view.addSubview(loadingWheel)
        loadingWheel.center = master.view.center
        loadingWheel.startAnimating()
      }
      Alamofire.request(.GET, formattedURL).responseJSON() { response in
        SAFE(response.result.value) { response in
          var obj = JSON(response)
          if let climberPath = climberPath {
            obj = self.traverseJSON(&obj, path: climberPath)!
          }
          self.focus = obj
          }
        SAFE(self.loadingWheel) { $0.stopAnimating() ; $0.removeFromSuperview() }
      }
    }
  }
  
  func createURL(category: API_category, params: [(key:String, value:String)]? = nil) -> String {
    var out: String = "http://pokeapi.co/api/v2/\(category.rawValue)"
    var count = 0
    SAFE(params) { params in
      for param in params {
        out += "/\(param.value)"
      }
    }
    return out
  }
  
  
  // MARK: -- tableView functions
  func reloadTableView() {
    SAFECAST(master, type: MainViewController.self) { master in
      master.tblData.reloadData()
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableDataList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: CustomCell = CustomCell()  // should not fire
    SAFECAST(master, type: MainViewController.self) { master in
      cell = master.tblData.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
      cell.assocURL = self.tableDataList[indexPath.row].id
      cell.textLabel?.text = self.tableDataList[indexPath.row].obj.stringValue
      cell.backgroundColor = {indexPath.row % 2 == 0 ? UIColor.flatGrayColor() : UIColor.flatGrayColorDark()}()
      
    
    }
   
    return cell
    
  }
  
  func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    SAFECAST(master, type: MainViewController.self) { master in
      let selectedRow = master.tblData.cellForRowAtIndexPath(indexPath) as! CustomCell
      selectedRow.contentView.backgroundColor = master.mainColor
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   SAFECAST(master, type: MainViewController.self) { master in
    let selectedRow = master.tblData.cellForRowAtIndexPath(indexPath) as! CustomCell
    SAFE(selectedRow.assocURL) { url in
      selectedRow.contentView.backgroundColor = master.mainColor
      
      master.loadSegue(url)
    }
    }
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    SAFECAST(master, type: MainViewController.self) { master in
      let selectedRow = master.tblData.cellForRowAtIndexPath(indexPath)
      selectedRow?.contentView.backgroundColor = {indexPath.row % 2 == 0 ? UIColor.flatGrayColor() : UIColor.flatGrayColorDark()}()
    }
  }
  
  
  
  
  // MARK: -- required functions
  init(master: MainViewController) {
    super.init(_master: master)
    doWasCreated()
  }
  
} // end of model class