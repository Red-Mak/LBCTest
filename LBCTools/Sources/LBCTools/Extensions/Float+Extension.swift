//
//  Float+Extension.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 24/06/2022.
//

import Foundation

public extension Float {
  var formatted: String? {
    return NumberFormatter.currencyFormatter.string(from: NSNumber(value: self))
  }
}
