//
//  Order.swift
//  HotCoffee
//
//  Created by Myron Dulay on 2/13/21.
//

import Foundation

enum CoffeeSize: String, Codable, CaseIterable {
  case small
  case medium
  case large
}

enum CoffeeType: String, Codable, CaseIterable {
  case latte
  case cappuccino
  case cortado
  case espresso
}

struct Order: Codable {
  let name: String?
  let email: String?
  let type: CoffeeType?
  let size: CoffeeSize?
}

extension Order {
  
  static var all: Resource<[Order]> = {
    
    guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
      fatalError("URL is incorrect")
    }
    
    return Resource<[Order]>(url: url)
  }()
  
  
  static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
    let order = Order(vm)
    guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
      fatalError("URL is incorrect")
    }
    
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    
    guard let data = try? jsonEncoder.encode(order) else {
      fatalError("Error encoding order!")
    }
  
    var resource = Resource<Order?>(url: url)
    resource.httpMethod = HTTPMethod.post
    resource.body = data
    return resource
    
    
    
  }
}

extension Order {
  
  init?(_ vm: AddCoffeeOrderViewModel) {
    
    guard let name = vm.name,
          let email = vm.email,
          let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
          let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
      return nil
    }
    
    self.name = name
    self.email = email
    self.type = selectedType
    self.size = selectedSize
  }
}
