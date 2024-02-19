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
    @EnvironmentObject private var toastModel: ItemStoreToast
    
    @Binding private var isCartViewPresented: Bool
    
    init(isCartViewPresented: Binding<Bool>) {
        self._isCartViewPresented = isCartViewPresented
    }
    
    var isFrogStateGreat: Bool {
        frogModel.frog?.state == .great
    }
    
    var body: some View {
        VStack {
            if isFrogStateGreat && !cart.items.isEmpty {
                //"지구리 기분이 좋아서 할인"
                Text("cartView.frogstate.great.discount.\(FrogState.frogInGreatMoodDiscountPercentPoint).description")
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.top, -8)
            }
            HStack(alignment: .center) {
                totalPriceDescription
                checkoutButton
            }
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private var totalPriceDescription: some View {
        Text(
            String(
                localized: "cartView.total.price.description",
                defaultValue: "TOTAL"
            )
        )
        .font(.headline)
        
        if cart.items.isEmpty {
            Text(
                String(
                    localized: "cartViewFooter.cart.is.empty",
                    defaultValue: "Cart is empty"
                )
            )
            .font(.caption2)
            .frame(maxWidth: .infinity)
        } else {
            totalPriceLabel
        }
        
    }
    
    private var totalPriceLabel: some View {
        
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
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.red)
                }
            }
            
            if isFrogStateGreat {
                Text(cart.discountedPrice, format: .number)
                    .font(.headline)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var checkoutButton: some View {
        Button {
            cart.send(.checkout(isFrogHappy: frogModel.frog?.state == .great))
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
        .disabled(cart.items.isEmpty)
        .onChange(of: cart.payingState, perform: { payingState in
            switch payingState {
            case .success: paidSuccessfully()
            case .canNotAfford: canNotAffordToBuy()
            case .failed: failedToCheckingOut()
            default: break
            }
        })
    }
    
    private func paidSuccessfully() {
        toastModel.send(.checkedOutSuccessfully(itemCount: cart.items.count))
        cart.send(.reset)
        isCartViewPresented = false
    }
    
    private func canNotAffordToBuy() {
        toastModel.send(.canNotAffordToBuy)
    }
    
    private func failedToCheckingOut() {
        toastModel.send(.failedToCheckingOut)
    }
}




#Preview {
    let container: DIContainer = .init(services: StubService())
    
    return CartViewFooter(isCartViewPresented: .constant(true))
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
