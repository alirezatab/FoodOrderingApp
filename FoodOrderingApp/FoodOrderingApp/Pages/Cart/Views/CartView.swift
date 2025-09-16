//
//  CartView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @StateObject private var upsellViewModel = UpsellViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if cartViewModel.isEmpty {
                    EmptyCartView()
                } else {
                    CartContentView(
                        cartViewModel: cartViewModel,
                        upsellViewModel: upsellViewModel
                    )
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                if !cartViewModel.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            cartViewModel.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            // Check for upsell opportunities
            upsellViewModel.checkForUpsell(
                cartSubtotal: cartViewModel.subtotal,
                cartViewModel: cartViewModel
            )
        }
        .onChange(of: cartViewModel.subtotal) { newSubtotal in
            upsellViewModel.checkForUpsell(
                cartSubtotal: newSubtotal,
                cartViewModel: cartViewModel
            )
        }
    }
}

#Preview {
    CartView()
}
