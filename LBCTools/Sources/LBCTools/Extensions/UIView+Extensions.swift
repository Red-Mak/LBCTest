//
//  UIView+Extensions.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import Foundation
import UIKit

public extension UIView {
  func sameSizeAsSuperView(horizontalPadding: CGFloat = 0,
                           verticalPadding: CGFloat = 0) {
    guard let superView = self.superview else { return }
    self.topAnchor.constraint(equalTo: superView.topAnchor,
                              constant: verticalPadding).isActive = true
    self.bottomAnchor.constraint(equalTo: superView.bottomAnchor,
                                 constant: -verticalPadding).isActive = true
    self.trailingAnchor.constraint(equalTo: superView.trailingAnchor,
                                   constant: -horizontalPadding).isActive = true
    self.leadingAnchor.constraint(equalTo: superView.leadingAnchor,
                                  constant: horizontalPadding).isActive = true
  }
}
