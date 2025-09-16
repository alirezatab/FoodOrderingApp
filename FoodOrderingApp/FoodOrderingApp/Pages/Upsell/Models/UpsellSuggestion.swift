//
//  UpsellSuggestion.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct UpsellSuggestion: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let triggerThreshold: Double
    let category: String
    let imageURL: String?
    
    init(id: String, title: String, description: String, price: Double, triggerThreshold: Double = 20.0, category: String, imageURL: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.triggerThreshold = triggerThreshold
        self.category = category
        self.imageURL = imageURL
    }
}

// MARK: - Computed Properties
extension UpsellSuggestion {
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    var shouldShow: Bool {
        // This will be determined by the view model based on cart subtotal
        return true
    }
}

// MARK: - Sample Data
extension UpsellSuggestion {
    static let sampleSuggestions: [UpsellSuggestion] = [
        UpsellSuggestion(
            id: "item_16", // Match the MenuItem ID for Chocolate Lava Cake
            title: "Chocolate Lava Cake",
            description: "Molten center, served warm - perfect ending to your meal!",
            price: 6.00,
            triggerThreshold: 20.0,
            category: "Desserts",
            imageURL: nil
        ),
        UpsellSuggestion(
            id: "item_1", // Match the MenuItem ID for Garlic Bread
            title: "Garlic Bread",
            description: "Toasted sourdough with garlic butter - great addition to any order!",
            price: 4.50,
            triggerThreshold: 20.0,
            category: "Appetizers",
            imageURL: nil
        ),
        UpsellSuggestion(
            id: "item_6", // Match the MenuItem ID for Caesar Salad
            title: "Caesar Salad",
            description: "Classic with croutons and parmesan - add some greens to your order!",
            price: 7.00,
            triggerThreshold: 20.0,
            category: "Salads",
            imageURL: nil
        ),
        UpsellSuggestion(
            id: "item_21", // Match the MenuItem ID for Coke
            title: "Coke",
            description: "Refreshing 12 oz can - perfect to wash down your meal!",
            price: 1.50,
            triggerThreshold: 20.0,
            category: "Beverages",
            imageURL: nil
        )
    ]
}
