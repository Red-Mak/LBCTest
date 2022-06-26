//
//  ImagesList.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import Foundation

public struct ImagesList: Codable, Hashable {
  public let small: String?
  public let thumb: String?
  
  public init(small: String?, thumb: String?) {
    self.small = small
    self.thumb = thumb
  }
  
  public func imageURL(prioritizeSmall: Bool) -> String? {
    return prioritizeSmall ? (self.small ?? self.thumb) : (self.thumb ?? self.small)
  }
}
