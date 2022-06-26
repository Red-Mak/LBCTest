//
//  NetworkManager+Extension.swift
//  TestLBC
//
//  Created by Radhouani Malek on 26/06/2022.
//

import Foundation
import LBCNetwork


extension NetworkManager {
  
  /// this var is usefull if we have different environment in `production` versus `dev`, so we can use different hosts
  static var auto: NetworkManager {
    #if DEBUG
      return NetworkManager(
        with: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json",
        itemsURL: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
      )
    #else
    return NetworkManager(
      with: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json",
      itemsURL: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    )
    #endif
  }
}
