//
//  Items.swift
//  TestLBCTests
//
//  Created by Radhouani Malek on 26/06/2022.
//

import Foundation
import LBCNetwork
@testable import TestLBC

let date = Date()

func add(days: Int, to date: Date) -> Date {
  var dateComponent = DateComponents()
  dateComponent.day = 1
  let futureDate = Calendar.current.date(byAdding: dateComponent,
                                         to: date)
  return futureDate!
}

let item1 = Item(id: 1,
                 categoryId: 1,
                 title: "a title",
                 description: "a description",
                 price: 11,
                 imagesUrl: ImagesList(small: nil, thumb: nil),
                 creationDate: date,
                 isUrgent: false)

let item2 = Item(id: 2,
                 categoryId: 2,
                 title: "a title 2",
                 description: "a description 2",
                 price: 22,
                 imagesUrl: ImagesList(small: nil, thumb: nil),
                 creationDate: add(days: 1, to: date) ,
                 isUrgent: false)

let item3 = Item(id: 3,
                 categoryId: 2,
                 title: "a title 3",
                 description: "a description 3",
                 price: 33,
                 imagesUrl: ImagesList(small: nil, thumb: nil),
                 creationDate: add(days: 2, to: date) ,
                 isUrgent: true)


let itemCategory1 = ItemCategory(id: 1, name: "cat 1")
let itemCategory2 = ItemCategory(id: 2, name: "cat 2")

let sortedUrgetFirstlistItems = [ListItem(item: item3, category: itemCategory2),
                                 ListItem(item: item2, category: itemCategory2),
                                 ListItem(item: item1, category: itemCategory1)]
