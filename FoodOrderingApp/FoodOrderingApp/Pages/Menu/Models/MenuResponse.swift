//
//  MenuResponse.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct MenuResponse: Codable {
    let categories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
}
