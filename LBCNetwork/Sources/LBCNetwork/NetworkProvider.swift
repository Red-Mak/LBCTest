//
//  NetworkProvider.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import Foundation
import Combine

public protocol NetworkProvider {
  func items() -> AnyPublisher<[Item], Error>
  func categories() -> AnyPublisher<[ItemCategory], Error>
  func image(with url: URL, completion: @escaping (Result<Data, Error>) -> Void)
  func cancelRequest(with requestIdentifier: String)
}
