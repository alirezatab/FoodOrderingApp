//
//  MenuItem.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct MenuItem: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let category: String?
    let imageURL: String?
    let isAvailable: Bool
    
    init(id: String, name: String, description: String, price: Double, category: String? = nil, imageURL: String? = nil, isAvailable: Bool = true) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.category = category
        self.imageURL = imageURL
        self.isAvailable = isAvailable
    }
}

// MARK: - Computed Properties
extension MenuItem {
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    var displayPrice: String {
        return formattedPrice
    }
}

// MARK: - Codable Keys
extension MenuItem {
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, category, imageURL, isAvailable
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        isAvailable = try container.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? true
    }
}

// MARK: - Sample Data
extension MenuItem {
    static let sampleItems: [MenuItem] = [
        // Appetizers
        MenuItem(id: "item_1", name: "Garlic Bread", description: "Toasted sourdough with garlic butter", price: 4.50, category: "Appetizers"),
        MenuItem(id: "item_2", name: "Bruschetta", description: "Fresh tomato and basil on toasted bread", price: 5.00, category: "Appetizers"),
        MenuItem(id: "item_3", name: "Stuffed Mushrooms", description: "Mushrooms stuffed with cheese and herbs", price: 6.25, category: "Appetizers"),
        MenuItem(id: "item_4", name: "Spinach Artichoke Dip", description: "Served with tortilla chips", price: 7.50, category: "Appetizers"),
        MenuItem(id: "item_5", name: "Fried Calamari", description: "Served with marinara sauce", price: 8.00, category: "Appetizers"),
        
        // Salads
        MenuItem(id: "item_6", name: "Caesar Salad", description: "Classic with croutons and parmesan", price: 7.00, category: "Salads"),
        MenuItem(id: "item_7", name: "Greek Salad", description: "Feta, olives, cucumber, tomato", price: 7.50, category: "Salads"),
        MenuItem(id: "item_8", name: "House Salad", description: "Mixed greens and seasonal vegetables", price: 6.50, category: "Salads"),
        MenuItem(id: "item_9", name: "Kale Quinoa Salad", description: "Superfood mix with lemon vinaigrette", price: 8.50, category: "Salads"),
        MenuItem(id: "item_10", name: "Asian Chicken Salad", description: "Ginger dressing and crispy wontons", price: 9.25, category: "Salads"),
        
        // Entrees
        MenuItem(id: "item_11", name: "Grilled Salmon", description: "Served with rice and vegetables", price: 15.00, category: "Entrees"),
        MenuItem(id: "item_12", name: "Ribeye Steak", description: "12 oz grilled to order", price: 22.00, category: "Entrees"),
        MenuItem(id: "item_13", name: "Pasta Primavera", description: "Mixed vegetables in light cream sauce", price: 13.00, category: "Entrees"),
        MenuItem(id: "item_14", name: "Chicken Alfredo", description: "Creamy alfredo with grilled chicken", price: 14.50, category: "Entrees"),
        MenuItem(id: "item_15", name: "Vegetarian Lasagna", description: "Layers of pasta and veggies", price: 12.75, category: "Entrees"),
        
        // Desserts
        MenuItem(id: "item_16", name: "Chocolate Lava Cake", description: "Molten center, served warm", price: 6.00, category: "Desserts"),
        MenuItem(id: "item_17", name: "Cheesecake", description: "New York style with strawberry sauce", price: 5.75, category: "Desserts"),
        MenuItem(id: "item_18", name: "Tiramisu", description: "Classic Italian coffee-flavored dessert", price: 6.25, category: "Desserts"),
        MenuItem(id: "item_19", name: "Apple Pie", description: "Served with vanilla ice cream", price: 5.50, category: "Desserts"),
        MenuItem(id: "item_20", name: "Ice Cream Sundae", description: "Chocolate, nuts, whipped cream", price: 4.75, category: "Desserts"),
        
        // Beverages
        MenuItem(id: "item_21", name: "Coke", description: "12 oz can", price: 1.50, category: "Beverages"),
        MenuItem(id: "item_22", name: "Sparkling Water", description: "Lemon or lime", price: 2.00, category: "Beverages"),
        MenuItem(id: "item_23", name: "Lemonade", description: "Freshly squeezed", price: 2.50, category: "Beverages"),
        MenuItem(id: "item_24", name: "Iced Tea", description: "Sweetened or unsweetened", price: 2.25, category: "Beverages"),
        MenuItem(id: "item_25", name: "Coffee", description: "Fresh brewed", price: 1.75, category: "Beverages")
    ]
}
