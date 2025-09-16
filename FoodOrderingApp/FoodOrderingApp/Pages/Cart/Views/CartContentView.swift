//
//  CartContentView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct CartContentView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @ObservedObject var upsellViewModel: UpsellViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Cart Items
                CartItemsSection(cartViewModel: cartViewModel)
                
                // Upsell Suggestion
                if upsellViewModel.shouldShowSuggestion {
                    UpsellCard(upsellViewModel: upsellViewModel, cartViewModel: cartViewModel)
                }
                
                // Order Summary
                OrderSummarySection(cartViewModel: cartViewModel)
                
                // Checkout Button
                CheckoutButton(cartViewModel: cartViewModel)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct CartItemsSection: View {
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Order")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
            
            LazyVStack(spacing: 8) {
                ForEach(cartViewModel.cartItems) { cartItem in
                    CartItemRow(cartItem: cartItem, cartViewModel: cartViewModel)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct CartItemRow: View {
    let cartItem: CartItem
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Item Image Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                )
            
            // Item Details
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(cartItem.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Quantity Controls
            HStack(spacing: 12) {
                Button(action: {
                    // Find the menu item and remove it
                    if let menuItem = findMenuItem(for: cartItem) {
                        cartViewModel.removeItem(menuItem)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
                
                Text("\(cartItem.quantity)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(minWidth: 20)
                
                Button(action: {
                    // Find the menu item and add it
                    if let menuItem = findMenuItem(for: cartItem) {
                        cartViewModel.addItem(menuItem)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
            }
            
            // Subtotal
            Text(cartItem.formattedSubtotal)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
    
    private func findMenuItem(for cartItem: CartItem) -> MenuItem? {
        // This is a simplified approach - in a real app you'd want to maintain a reference
        // or have a more sophisticated lookup mechanism
        return MenuItem(
            id: cartItem.menuItemID,
            name: cartItem.name,
            description: "",
            price: cartItem.price
        )
    }
}

struct OrderSummarySection: View {
    @ObservedObject var cartViewModel: CartViewModel
    @State private var showTipSelector = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                // Subtotal
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text(cartViewModel.formattedSubtotal)
                }
                .font(.body)
                
                // Tax
                HStack {
                    Text("Tax (8%)")
                    Spacer()
                    Text(cartViewModel.cartSummary.formattedTax)
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                // Delivery Fee
                HStack {
                    Text("Delivery Fee")
                    Spacer()
                    Text(cartViewModel.cartSummary.formattedDelivery)
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                // Service Fee
                HStack {
                    Text("Service Fee")
                    Spacer()
                    Text(cartViewModel.cartSummary.formattedFees)
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                // Tip
                HStack {
                    Text("Tip")
                    Spacer()
                    Text(cartViewModel.cartSummary.formattedTip)
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                Divider()
                
                // Total
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(cartViewModel.formattedTotal)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
            }
            
            // Tip Selector Button
            Button(action: {
                showTipSelector = true
            }) {
                HStack {
                    Text("Add Tip")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .foregroundColor(.orange)
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showTipSelector) {
            TipSelectorView(cartViewModel: cartViewModel)
        }
    }
}

struct CheckoutButton: View {
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        Button(action: {
            cartViewModel.proceedToCheckout()
        }) {
            HStack {
                Text("Proceed to Checkout")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(cartViewModel.formattedTotal)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(16)
        }
        .padding(.bottom, 20)
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Your Cart is Empty")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Add some delicious items from our menu to get started!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
