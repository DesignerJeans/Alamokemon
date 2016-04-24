//
//  colors.swift
//  alamokemon
//
//  Created by Jaden Nation on 4/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import ChameleonFramework

enum flatColor {
  case red
  case skyBlue
  case green
  case flatBlue
  case flatPowderBlue
}

var colors: [flatColor : (light: UIColor, dark: UIColor)] = [
  .red: (UIColor.flatRedColor(), UIColor.flatRedColorDark()),
  .skyBlue: (UIColor.flatSkyBlueColor(), UIColor.flatSkyBlueColorDark()),
  .green: (UIColor.flatGreenColor(), UIColor.flatGreenColorDark()),
  .flatBlue: (UIColor.flatBlueColor(), UIColor.flatBlueColorDark()),
  .flatPowderBlue: (UIColor.flatPowderBlueColor(), UIColor.flatPowderBlueColorDark()),
]




