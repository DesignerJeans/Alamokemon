//
//  MainViewController.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: BetterViewController {
  // MARK: -- outlets
  @IBOutlet weak var tblData: UITableView!
  @IBOutlet weak var tlbarMain: UIToolbar!
  @IBOutlet weak var btnPokemon: UIBarButtonItem!
  @IBOutlet weak var btnAbilities: UIBarButtonItem!
  @IBOutlet weak var btnTypes: UIBarButtonItem!
  
  @IBAction func clickedToolbarBtn(sender: UIBarButtonItem) {doHandleToolbarButton(sender.tag)  }
  
  // MARK: -- variables
  var mainColor: UIColor? ; var secondaryColor: UIColor?
//  var cheatList = ["Hey", "Man", "Nice", "Shot"]
  
  // MARK: -- custom functions
  func doHandleToolbarButton(tag: Int) {
    
  }
  
  
  func setColors() {
    dispatchToMain {
      self.navigationController?.navigationBar.barTintColor = UIColor.flatBlackColorDark()
      self.navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
      self.mainColor = UIColor.flatWhiteColor()
      self.secondaryColor = UIColor.flatGrayColor()
      self.view.backgroundColor = self.mainColor
      self.tlbarMain.tintColor = self.mainColor
      self.tblData.backgroundColor = UIColor.flatGrayColorDark()
    }
  }
  
  func didLoadStuff() {
    model = Main_Model(master: self)
    SAFECAST(model, type: Main_Model.self) { model in
      self.tblData.dataSource = model
      self.tblData.delegate = model
    }
    
  }
  
  func willAppearStuff() {
    setColors()
  }
  
  func didAppearStuff() {
    SAFECAST(model, type: Main_Model.self) { model in
      model.getPageOf(model.category)
    }
  }
  
  // MARK: -- segue functions
  func loadSegue(url: JSON) {
    let vagueURL = url.stringValue
    performSegueWithIdentifier("segueToDetail", sender: vagueURL)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    SAFE(segue.identifier) { id in
      switch id {
        case "segueToDetail":
          PS("segueToDetail")
          if let dest = segue.destinationViewController as? DetailViewController {
            print("Explicit call to DetailViewController")
            if let selectedRow = self.tblData.indexPathForSelectedRow { self.tblData.deselectRowAtIndexPath(selectedRow, animated: false) }
            if let sender = sender as? String {
              dest.focusURL = sender
            }
          }
      default:
        break
      }
    }
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

