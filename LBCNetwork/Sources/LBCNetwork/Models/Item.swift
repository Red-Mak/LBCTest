//
//  Item.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import Foundation

public struct Item: Codable, Identifiable, Hashable {
  public let id: Int
  public let categoryId: Int
  public let title: String
  public let description: String
  public let price: Float
  public let imagesUrl: ImagesList
  public let creationDate: Date
  public let isUrgent: Bool
  
  public init(id: Int,
              categoryId: Int,
              title: String,
              description: String,
              price: Float,
              imagesUrl: ImagesList,
              creationDate: Date,
              isUrgent: Bool) {
    self.id = id
    self.categoryId = categoryId
    self.title = title
    self.description = description
    self.price = price
    self.imagesUrl = imagesUrl
    self.creationDate = creationDate
    self.isUrgent = isUrgent
  }
}
