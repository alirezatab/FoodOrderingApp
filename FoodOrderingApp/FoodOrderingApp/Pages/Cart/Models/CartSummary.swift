//
//  CartSummary.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation

struct CartSummary: Codable {
    let totalItems: Int
    let subtotal: Double
    let tax: Double
    let tip: Double
    let fees: Double
    let delivery: Double
    let total: Double
    
    init(totalItems: Int, subtotal: Double, tax: Double = 0.0, tip: Double = 0.0, fees: Double = 0.0, delivery: Double = 0.0) {
        self.totalItems = totalItems
        self.subtotal = subtotal
        self.tax = tax
        self.tip = tip
        self.fees = fees
        self.delivery = delivery
        self.total = subtotal + tax + tip + fees + delivery
    }
}

// MARK: - Computed Properties
extension CartSummary {
    var formattedSubtotal: String {
        return String(format: "$%.2f", subtotal)
    }
    
    var formattedTax: String {
        return String(format: "$%.2f", tax)
    }
    
    var formattedTip: String {
        return String(format: "$%.2f", tip)
    }
    
    var formattedFees: String {
        return String(format: "$%.2f", fees)
    }
    
    var formattedDelivery: String {
        return String(format: "$%.2f", delivery)
    }
    
    var formattedTotal: String {
        return String(format: "$%.2f", total)
    }
    
    var hasAdditionalCharges: Bool {
        return tax > 0 || tip > 0 || fees > 0 || delivery > 0
    }
}

// MARK: - Static Factory Methods
extension CartSummary {
    static func from(cartItems: [CartItem], taxRate: Double = 0.08, tipPercentage: Double = 0.0, deliveryFee: Double = 2.99, serviceFee: Double = 1.50) -> CartSummary {
        let totalItems = cartItems.reduce(0) { $0 + $1.quantity }
        let subtotal = cartItems.reduce(0.0) { $0 + $1.subtotal }
        let tax = subtotal * taxRate
        let tip = subtotal * tipPercentage
        let fees = serviceFee
        let delivery = deliveryFee
        
        return CartSummary(
            totalItems: totalItems,
            subtotal: subtotal,
            tax: tax,
            tip: tip,
            fees: fees,
            delivery: delivery
        )
    }
    
    static let empty = CartSummary(totalItems: 0, subtotal: 0.0)
}
