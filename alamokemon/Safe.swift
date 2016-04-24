//
//  File.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation


func SAFE<T>(opt: T?, closure: ((T)->())? = nil) -> Bool {
  if let unwrappedOpt = opt {
    if let closure = closure {
      closure(unwrappedOpt)
    }
    return true
  }
  return false
}

func SAFECAST<T, U>(opt: T?, type: U.Type, closure: ((U) -> ())? = nil) -> Bool {
  if let opt = opt {
    if opt is U {
      if let closure = closure { closure(opt as! U) }
      return true
    }
  }
  return false
}