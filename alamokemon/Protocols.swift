//
//  Protocols.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import SwiftyJSON


typealias tableViewJSONObj = (id:JSON?, obj: JSON)


protocol ListsAPIObjects {
  var tableDataList: [tableViewJSONObj] { get set }
  var focus: JSON? { get set }
}