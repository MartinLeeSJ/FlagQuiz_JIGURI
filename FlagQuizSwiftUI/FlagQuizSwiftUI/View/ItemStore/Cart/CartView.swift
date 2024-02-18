//
//  CartView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct CartView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var cart: CartModel
    @Binding private var isCartViewPresented: Bool
 
    init(
        isCartViewPresented: Binding<Bool>
    ) {
        self._isCartViewPresented = isCartViewPresented
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let topPadding: CGFloat = width > height ? 5 : 20
            let bottomPadding: CGFloat = width > height ? 10 : 40
            
            VStack {
                header
                
                CartItemList()
                    
                Divider()
                
                CartViewFooter(isCartViewPresented: $isCartViewPresented)
               
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
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
        }
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
        Text("cartView.total.items.count.\(cart.items.count)")
            .font(.caption)
            .fontWeight(.medium)

        
        Divider()
    }

    
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    return ZStack {
        CartView(
            isCartViewPresented: .constant(true)
        )
        .environmentObject(
            EarthCandyModel(
                container: container
            )
        )
    }
}
