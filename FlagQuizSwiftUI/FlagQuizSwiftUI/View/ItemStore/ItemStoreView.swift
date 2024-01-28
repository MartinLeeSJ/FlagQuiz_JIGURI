//
//  ItemStoreView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import SwiftUI

struct ItemStoreView: View {
    @Environment(\.locale) var locale
    @State private var selectedType: FQItemType? = nil
    @State private var wearingItems: [FQItem] = [
        .init(
            id: "1",
            type: .gloves,
            names: [
                .init(languageCode: .EN, name: "Mitten"),
                .init(languageCode: .KO, name: "손모아장갑")
            ],
            price: 200,
            isOnMarket: true
        ),
        .init(
            id: "2",
            type: .hair,
            names: [
                .init(languageCode: .EN, name: "CurlyHair"),
                .init(languageCode: .KO, name: "곱슬머리")
            ],
            price: 200,
            isOnMarket: true
        )
    ]
    
    private var languageCodeString: String {
        guard let code = locale.language.languageCode?.identifier(.alpha2) else {
            return "en"
        }
        if code == "ko" {
            return code
        }
        
        return "en"
    }
    
    private var colums: [GridItem] {
        Array<GridItem>(repeating: .init(.adaptive(minimum: 64, maximum: 84)), count: 4)
    }
    
    var body: some View {
        VStack {
            Image("frogGood")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200)
                .padding(25)
                .background(in: .rect(cornerRadius: 12, style: .continuous))
                .backgroundStyle(.thinMaterial)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(wearingItems, id: \.self) { item in
                        Button {
                            if let index = wearingItems.firstIndex(where: { $0 == item }) {
                                _ = withAnimation {
                                    wearingItems.remove(at: index)
                                }
                            }
                        } label: {
                            Text(localizedItemName(of: item))
                            Image(systemName: "xmark")
                                .fontWeight(.bold)
                        }
                        .font(.caption)
                        .foregroundStyle(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(in: .rect(cornerRadius: 4, style: .continuous))
                        .backgroundStyle(.fqAccent.opacity(0.35))
                        .animation(.easeInOut, value: wearingItems)
                    }
                }
                .safeAreaInset(edge: .leading) {}
            }
            .frame(idealHeight: 42, maxHeight: 45)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(FQItemType.allCases, id: \.self) { type in
                        Button {
                           selectedType = type
                        } label: {
                            Text(type.localizedName)
                                .foregroundStyle(.foreground)
                                .font(.caption)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background {
                            Capsule(style: .continuous)
                                .stroke(
                                    selectedType == type ? .fqAccent : .gray,
                                    lineWidth: selectedType == type ? 2 : 1
                                )
                        }
                        .animation(.easeInOut, value: selectedType)
                    }
                }
                .safeAreaInset(edge: .leading) {}
                .safeAreaInset(edge: .trailing) {}
            }
            .scrollIndicators(.hidden)
            .frame(idealHeight: 42, maxHeight: 45)
            
            Divider()
                .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: colums) {
                    ForEach(0..<4) {
                        VStack {
                            Rectangle()
                                .scaledToFit()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: 84)
                            Label {
                                Text("300")
                            } icon: {
                                Image("EarthCandy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            }
                        }
                    }

                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image("EarthCandy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    //TODO: - EarthCandy연동하기
                    Text("120")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text(String(localized: "itemStoreView.quit", defaultValue: "Quit"))
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    func localizedItemName(of item: FQItem) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
}



#Preview {
    NavigationStack {
        ItemStoreView()
    }
}
