//
//  ItemCellViewModel.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import Foundation
import UIKit
import Combine
import LBCNetwork

class ItemCellViewModel: ObservableObject {
  private let networkProvider: NetworkProvider
  var imageData = CurrentValueSubject<UIImage?, Never>(UIImage(systemName: "gift"))
  
  enum Action {
    case loadImageData(images: ImagesList)
    case cancelCurrentImageLoading(url: String)
  }
  
  init(with networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }
  
  /// This func should be the only way the ViewController interract with the viewModel
  /// - Parameter action: the action that the viewController need
  func handle(action: Action) {
    
    switch action {
    case .loadImageData(let images):
      guard let url = URL(string: images.imageURL(prioritizeSmall: true) ?? "") else {
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
      
    case .cancelCurrentImageLoading(let url):
      self.networkProvider.cancelRequest(with: url)
    }
  }
}
