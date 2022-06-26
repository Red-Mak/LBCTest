//
//  DateFormatter+Extension.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 24/06/2022.
//

import Foundation

extension DateFormatter {
  static let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateStyle = .medium

    return dateFormatter
  }()
}
