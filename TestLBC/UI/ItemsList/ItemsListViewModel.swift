//
//  ItemsListViewModel.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import Foundation
import Combine
import LBCNetwork

class ItemsListViewModel: ObservableObject {
  
  enum FilterType: Equatable {
    case none
    case category(ItemCategory)
    
    var title: String {
      switch self {
      case .none:
        return "Aucun filtre"
      case .category(let category):
        return category.name
      }
    }
  }
  
  enum Action {
    case fetchItems
    case filter(type: FilterType)
  }
  
  private var cancellables : Set<AnyCancellable> = []
  private var fetchedListItems = [ListItem]()
  private(set) var currentListItems = CurrentValueSubject<[ListItem], Error>([])
  private(set) var currentFilter = FilterType.none
  private(set) var filters = [FilterType.none]
  private let networkProvider: NetworkProvider
  
  init(with provider: NetworkProvider) {
    self.networkProvider = provider
  }

//MARK: - Public
  
  /// This func should be the only way the ViewController interract with the viewModel
  /// - Parameter action: the action that the viewController need
  func handle(action: Action) {
    switch action {
    case .fetchItems:
      self.fetchItems()
    case .filter(let filterType):
      self.filter(by: filterType)
    }
  }
  
//MARK: - Private
  
  /// will fetch data and process it
  private func fetchItems() {
    let categoriesPublisher = self.networkProvider.categories()
    let itemsPublisher = self.networkProvider.items()
        
    categoriesPublisher
      .combineLatest(itemsPublisher)
      .sink { error in
        print(error)
      } receiveValue: { (categories, items) in
        self.processData(categories: categories, items: items)
      }
      .store(in: &self.cancellables)
  }
  
  /// will create the available filters (categories) and deliver sorted data + move all urgent items to the top
  private func processData(categories: [ItemCategory], items: [Item]) {
    self.filters = [.none]
    self.filters += categories.map({ category in
      FilterType.category(category)
    })
    
    var newItems: [ListItem] = items.compactMap { item in
      guard let relatedCategory = categories.first(where: { $0.id == item.categoryId }) else { return nil }
      return ListItem(item: item, category: relatedCategory)
    }
    .sorted { $0.item.creationDate > $1.item.creationDate }
    
    var urgentItems = [ListItem]()
    
    newItems.removeAll(where: {
      if $0.item.isUrgent {
        urgentItems.append($0)
        return true
      }
      return false
    })
    self.fetchedListItems = urgentItems + newItems
    self.currentListItems.send(self.fetchedListItems)
  }
  
  /// will apply the desired filter to the list
  private func filter(by filter: FilterType) {
    guard self.currentFilter != filter else { return }
    
    self.currentFilter = filter

    guard self.currentFilter != .none else {
      self.currentListItems.value = self.fetchedListItems
      return
    }
    
    self.currentListItems.value = self.fetchedListItems.filter { listItem in
      guard case let FilterType.category(categorie) = self.currentFilter,
            listItem.item.categoryId == categorie.id else {
        return false
      }
      return true
    }
  }
}
