//
//  CartViewFooter.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/30/24.
//

import SwiftUI

struct CartViewFooter: View {
    @EnvironmentObject private var cart: CartModel
    @EnvironmentObject private var frogModel: FrogModel
    
    var isFrogStateGreat: Bool {
        frogModel.frog?.state == .great
    }
    
    var body: some View {
        HStack(alignment: .top) {
            totalPriceDescription
            checkoutButton
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private var totalPriceDescription: some View {
        Text(
            String(
                localized: "cartView.total.price.description",
                defaultValue: "TOTAL"
            )
        )
        .font(.caption)
        
        
        VStack {
            HStack(spacing: 12) {
                Label {
                    Text(cart.totalPrice, format: .number)
                        .font(isFrogStateGreat ? .caption : .subheadline)
                        .monospacedDigit()
                } icon: {
                    Image("EarthCandy")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: isFrogStateGreat ? 10 : 15)
                }
                .overlay {
                    if isFrogStateGreat {
                        Line()
                            .stroke(style: .init(lineCap: .round))
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.red)
                    }
                }
                
                if isFrogStateGreat {
                    Text(cart.discountedPrice, format: .number)
                        .font(.headline)
                        .monospacedDigit()
                }
            }
            
            if isFrogStateGreat {
                //"지구리 기분이 좋아서 할인"
                Text("cartView.frogstate.great.discount.\(FrogState.frogInGreatMoodDiscountPercentPoint).description")
                    .font(.caption2)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var checkoutButton: some View {
        Button {
            cart.send(.checkout)
        } label: {
            Text(String(localized:"cartView.checkout.button.title", defaultValue: "Check Out"))
                .foregroundStyle(.foreground)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundStyle(.fqAccent)
        }
    }
}




#Preview {
    let container: DIContainer = .init(services: StubService())
    
    return CartViewFooter()
        .environmentObject(
            CartModel(container: container)
        )
        .environmentObject(
            FrogModel(
                container: container,
                notificationManager: NotificationManager()
            )
        )
}
