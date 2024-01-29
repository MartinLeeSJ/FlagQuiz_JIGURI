//
//  ItemStoreView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import SwiftUI

struct ItemStoreView: View {
    @Environment(\.locale) var locale
    @State private var selectedType: FQItemType? = .hair
    @State private var storeItems: [FQItem] = FQItem.mockItems
    @State private var wearingItems: [FQItem] = []
    @State private var cartSet: Set<FQItem> = .init()
    @State private var isCartViewPresented: Bool = false
    
    private var languageCodeString: String {
        guard let code = locale.language.languageCode?.identifier(.alpha2) else {
            return "en"
        }
        if code == "ko" {
            return code
        }
        
        return "en"
    }
    
    private var currentTypeItems: [FQItem] {
        guard let selectedType else { return [] }
        return storeItems.filter { $0.type == selectedType }
    }
    
    var body: some View {
        GeometryReader { geo in
            Group {
                if geo.size.width < geo.size.height {
                    verticalContent
                } else {
                    horizontalContent
                }
            }
            .blur(radius: isCartViewPresented ? 3 : 0)
            .onTapGesture {
                if isCartViewPresented {
                    isCartViewPresented = false
                }
            }
            
            if isCartViewPresented {
                Rectangle()
                    .fill(.red)
                    .padding(.horizontal)
                    .padding(.vertical, 120)
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
    
    private var verticalContent: some View {
        VStack {
            ItemStoreFrogView()
            
            ItemStoreWearingClothes(
                wearingItems: $wearingItems,
                languageCodeString: languageCodeString
            )
            
            ItemTypeButtons(selectedType: $selectedType)
            
            
            Divider()
                .padding(.horizontal)
            
            StoreItemGrid(
                wearingItems: $wearingItems,
                cartSet: $cartSet,
                isCartViewPresented: $isCartViewPresented,
                currentTypeItems: currentTypeItems,
                languageCodeString: languageCodeString
            )
        }
    }
    
    private var horizontalContent: some View {
        HStack {
            VStack {
                ItemStoreFrogView()
                
                ItemStoreWearingClothes(
                    wearingItems: $wearingItems,
                    languageCodeString: languageCodeString
                )
            }
            VStack {
                ItemTypeButtons(selectedType: $selectedType)
                
                
                Divider()
                    .padding(.horizontal)
                
                StoreItemGrid(
                    wearingItems: $wearingItems,
                    cartSet: $cartSet,
                    isCartViewPresented: $isCartViewPresented,
                    currentTypeItems: currentTypeItems,
                    languageCodeString: languageCodeString
                )
            }
        }
    }
}



#Preview {
    NavigationStack {
        ItemStoreView()
    }
}
