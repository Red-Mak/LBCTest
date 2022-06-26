//
//  ItemDetailsViewModel.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import Foundation
import Combine
import UIKit
import LBCNetwork

class ItemDetailsViewModel: ObservableObject {
  
  enum Action {
    case loadImageData
  }
  
  var imageData = CurrentValueSubject<UIImage?, Never>(UIImage(systemName: "gift"))
  private(set) var listItem: ListItem
  private let networkProvider: NetworkProvider
  
  init(with item: ListItem, networkProvider: NetworkProvider) {
    self.listItem = item
    self.networkProvider = networkProvider
  }
  
  func handle(action: Action) {
    switch action {
    case .loadImageData:
      guard let url = URL(string: self.listItem.item.imagesUrl.imageURL(prioritizeSmall: true) ?? "") else {
        self.imageData.send(UIImage(systemName: "gift"))
        return
      }

      self.networkProvider.image(with: url) { result in
        switch result {
        case .success(let data):
          self.imageData.send(UIImage(data: data))
        case .failure:
          self.imageData.send(UIImage(systemName: "gift"))
        }
      }
    }
  }
}
