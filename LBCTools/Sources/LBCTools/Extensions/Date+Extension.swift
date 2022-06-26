//
//  Date+Extension.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 24/06/2022.
//

import Foundation

public extension Date {
  var formatted: String {
    return DateFormatter.formatter.string(from: self)
  }
}
