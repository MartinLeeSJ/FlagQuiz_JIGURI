//
//  CartView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct CartView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var earthCandyViewModel: EarthCandyViewModel
    @StateObject private var viewModel: CartViewModel
    @Binding private var isCartViewPresented: Bool
 
    init(
        viewModel: CartViewModel,
        isCartViewPresented: Binding<Bool>
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isCartViewPresented = isCartViewPresented
    }
    
    var body: some View {
        VStack {
            header
            
            CartItemList()
                
            Divider()
            
            CartViewFooter()
           
        }
        .padding(16)
        .background(
            in: .rect(
                cornerRadius: 10,
                style: .continuous
            )
        )
        .backgroundStyle(.thinMaterial)
        .padding(.horizontal)
        .padding(.vertical, 60)
        .environmentObject(viewModel)
    }
    
    @ViewBuilder
    private var header: some View {
        HStack {
            Spacer()
            Button {
                isCartViewPresented = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(scheme == .light ? .gray : .white.opacity(0.4))
            }
            
        }
        Text("cartView.total.items.count.\(viewModel.cartItems.count)")
            .font(.caption)
            .fontWeight(.medium)

        
        Divider()
    }

    
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    return ZStack {
        CartView(
            viewModel: CartViewModel(cartItems: FQItem.mockItems, container: container),
            isCartViewPresented: .constant(true)
        )
        .environmentObject(
            EarthCandyViewModel(
                container: container
            )
        )
    }
}
