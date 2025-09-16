//
//  MenuContentView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct MenuContentView: View {
    let categories: [Category]
    let cartViewModel: CartViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(categories) { category in
                    CategorySection(
                        category: category,
                        cartViewModel: cartViewModel
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct CategorySection: View {
    let category: Category
    let cartViewModel: CartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category Header
            HStack {
                Text(category.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(category.itemCount) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 4)
            
            // Menu Items
            LazyVStack(spacing: 8) {
                ForEach(category.availableItems) { item in
                    MenuItemRow(
                        item: item,
                        cartViewModel: cartViewModel
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    let cartViewModel: CartViewModel
    
    @State private var quantity: Int = 0
    
    var body: some View {
        HStack(spacing: 12) {
            // Item Image Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                        .font(.title2)
                )
            
            // Item Details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(item.formattedPrice)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    // Quantity Controls
                    if quantity > 0 {
                        HStack(spacing: 8) {
                            Button(action: {
                                cartViewModel.removeItem(item)
                                quantity = max(0, quantity - 1)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                            
                            Text("\(quantity)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(minWidth: 20)
                            
                            Button(action: {
                                cartViewModel.addItem(item)
                                quantity += 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                        }
                    } else {
                        Button(action: {
                            cartViewModel.addItem(item)
                            quantity = 1
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .font(.caption)
                                Text("Add")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            quantity = cartViewModel.getQuantity(for: item)
        }
        .onChange(of: cartViewModel.getQuantity(for: item)) { newQuantity in
            quantity = newQuantity
        }
    }
}
