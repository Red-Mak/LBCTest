//
//  NetworkProviderMock.swift
//  TestLBCTests
//
//  Created by Radhouani Malek on 26/06/2022.
//

import Foundation
import Combine
import LBCNetwork

class NetworkProviderMock: NetworkProvider {
  
  let itemsArray: [Item]
  let categoriesArray: [ItemCategory]
  
  init(with items: [Item], categories: [ItemCategory]) {
    self.itemsArray = items
    self.categoriesArray = categories
  }

  func items() -> AnyPublisher<[Item], Error> {
    return Just(self.itemsArray).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  func categories() -> AnyPublisher<[ItemCategory], Error> {
    return Just(self.categoriesArray).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  func image(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {}
  
  func cancelRequest(with requestIdentifier: String) {}
}
