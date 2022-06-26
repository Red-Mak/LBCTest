//
//  NumberFormatter+Extension.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 24/06/2022.
//

import Foundation

extension NumberFormatter {
  static let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "EUR"
    formatter.locale = Locale.current

    return formatter
  }()
}
