//
//  ListItem.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import Foundation
import LBCNetwork

struct ListItem: Identifiable, Hashable {
  var id: Int {
    return item.id
  }
  
  let item: Item
  let category: ItemCategory
}
