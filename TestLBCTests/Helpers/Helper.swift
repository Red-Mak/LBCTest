//
//  Helper.swift
//  TestLBCTests
//
//  Created by Radhouani Malek on 25/06/2022.
//

import Foundation
import Combine

class Helper {
  
  static var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
}
