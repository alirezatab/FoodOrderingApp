//
//  CartItem.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id: String
    let menuItemID: String
    let name: String
    let price: Double
    let quantity: Int
    
    init(menuItem: MenuItem, quantity: Int = 1) {
        self.id = UUID().uuidString
        self.menuItemID = menuItem.id
        self.name = menuItem.name
        self.price = menuItem.price
        self.quantity = quantity
    }
    
    init(id: String, menuItemID: String, name: String, price: Double, quantity: Int) {
        self.id = id
        self.menuItemID = menuItemID
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

// MARK: - Computed Properties
extension CartItem {
    var subtotal: Double {
        return price * Double(quantity)
    }
    
    var formattedSubtotal: String {
        return String(format: "$%.2f", subtotal)
    }
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}

// MARK: - Mutating Functions
extension CartItem {
    func withQuantity(_ newQuantity: Int) -> CartItem {
        return CartItem(
            id: self.id,
            menuItemID: self.menuItemID,
            name: self.name,
            price: self.price,
            quantity: newQuantity
        )
    }
    
    func incrementQuantity() -> CartItem {
        return withQuantity(quantity + 1)
    }
    
    func decrementQuantity() -> CartItem {
        return withQuantity(max(0, quantity - 1))
    }
}
