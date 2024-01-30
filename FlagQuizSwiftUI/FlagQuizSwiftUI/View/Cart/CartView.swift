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
    @EnvironmentObject private var frogModel: FrogModel
    
    // 임시
    @State private var cartItem: [FQItem] = FQItem.mockItems
    
    var totalPrice: Int {
        cartItem.reduce(0) {
            $0 + ($1.isOnEvent ? $1.specialPrice : $1.price)
        }
    }
    
    var discountedPrice: Int {
        Int(Double(totalPrice) * 0.9)
    }
    
    var isFrogStateGreat: Bool {
        frogModel.frog?.state == .great
    }
    
    
    var body: some View {
        VStack {
            Text("cartView.total.items.count.\(cartItem.count)")
                .font(.title)

            
            Divider()
            
            List(cartItem) { item in
                HStack {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                        .frame(width: 60, height: 60)
                    
                    GeometryReader { geo in
                        let width = geo.size.width
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(item.type.localizedName)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                
                                Text(item.stockName)
                                    .lineLimit(1)
                            }
                            .padding(.top, 8)
                            .frame(height: geo.size.height, alignment: .top)
                            .frame(maxWidth: width * 0.65, alignment: .leading)
                            
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Image("EarthCandy")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                    
                                    Text(item.price, format: .number)
                                        .font(.system(size: 14))
                                        .overlay {
                                            if item.isOnEvent {
                                                Line()
                                                    .stroke(lineWidth: 2.5)
                                                    .foregroundStyle(.red)
                                            }
                                        }
             
                                    if item.isOnEvent {
                                        Text(item.specialPrice, format: .number)
                                            .font(.system(size: 14))
                                    }
                                }
                                
                                Text(item.isOnEvent ?
                                     String(localized: "cartView.discounted.price" ,defaultValue: "Discounted Price") :
                                        String(localized: "cartView.original.price" ,defaultValue: "Original Price")
                                )
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(height: geo.size.height, alignment: .center)
                            .frame(minWidth: 90, maxWidth: width * 0.35, alignment: .leading)
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button("delete", role: .destructive) {
                        
                    }
                }
            }
            .listStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal, -8)
            
            Divider()
            
            HStack(alignment: .top) {
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
                            Text(totalPrice, format: .number)
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
                            Text(discountedPrice, format: .number)
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
                
                
                Button {
                    
                } label: {
                    Text(String(localized:"cartView.checkout.button.title", defaultValue: "Check Out"))
                        .foregroundStyle(scheme == .light ? .black : Color.fqAccent )
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                }
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundStyle(scheme == .light ? .white : .black)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.fqAccent, lineWidth: 2)
                }
            }
            .padding(.vertical)
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
        .padding(.vertical, 80)
        .task {
            frogModel.observe()
        }
    }
    
    
    
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    return ZStack {
        CartView()
            .environmentObject(
                FrogModel(
                    container: container,
                    notificationManager: .init()
                )
            )
            .environmentObject(
                EarthCandyViewModel(
                    container: container
                )
            )
    }
}
