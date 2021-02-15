//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by Myron Dulay on 2/15/21.
//

import Foundation

struct AddCoffeeOrderViewModel {
  
  var name: String?
  var email: String?
  var selectedType: String?
  var selectedSize: String?
  
  var types: [String] {
    return CoffeeType.allCases.map { $0.rawValue.capitalized }.sorted()
  }
  
  var sizes: [String] {
    return CoffeeSize.allCases.map { $0.rawValue.capitalized }
  }
  
}
