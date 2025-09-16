//
//  Category.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let items: [MenuItem]
    
    init(id: String, name: String, items: [MenuItem] = []) {
        self.id = id
        self.name = name
        self.items = items
    }
}

// MARK: - Computed Properties
extension Category {
    var availableItems: [MenuItem] {
        return items.filter { $0.isAvailable }
    }
    
    var itemCount: Int {
        return availableItems.count
    }
}

// MARK: - Codable Keys
extension Category {
    enum CodingKeys: String, CodingKey {
        case id, name, items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        items = try container.decode([MenuItem].self, forKey: .items)
    }
}

// MARK: - Sample Data
extension Category {
    static let sampleCategories: [Category] = [
        Category(
            id: "1",
            name: "Appetizers",
            items: MenuItem.sampleItems.filter { $0.category == "Appetizers" }
        ),
        Category(
            id: "2",
            name: "Salads",
            items: MenuItem.sampleItems.filter { $0.category == "Salads" }
        ),
        Category(
            id: "3",
            name: "Entrees",
            items: MenuItem.sampleItems.filter { $0.category == "Entrees" }
        ),
        Category(
            id: "4",
            name: "Desserts",
            items: MenuItem.sampleItems.filter { $0.category == "Desserts" }
        ),
        Category(
            id: "5",
            name: "Beverages",
            items: MenuItem.sampleItems.filter { $0.category == "Beverages" }
        )
    ]
}
