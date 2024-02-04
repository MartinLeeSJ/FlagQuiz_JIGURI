//
//  ClosetItemGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import SwiftUI

struct ClosetItemGrid: View {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @Namespace private var closetItemGrid
    
    
    private var colums: [GridItem] {
        Array<GridItem>(repeating: .init(.flexible(minimum: 64, maximum: 84)), count: 4)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, alignment: .center) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.thinMaterial)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(systemName: "nosign")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
                    .overlay {
                        if closetViewModel.equippedItem[closetViewModel.selectedType] == nil {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(.fqAccent, lineWidth: 1.5)
                                
                        }
                    }
                    .onTapGesture {
                        closetViewModel.send(.takeOffItem(closetViewModel.selectedType))
                    }
                
                if let items = closetViewModel.itemsOfType[closetViewModel.selectedType] {
                    ForEach(items, id: \.self) { item in
                        VStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundStyle(.thinMaterial)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    StorageImageView(item.storageImagePath(equipped: false)) {
                                        ProgressView()
                                    }
                                    .scaledToFit()
                                }
                                .overlay {
                                    if let equipped = closetViewModel.equippedItem[item.type],
                                       equipped == item {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(.fqAccent, lineWidth: 1.5)
                                    }
                                    
                                }
                        }
                        .onTapGesture {
                            closetViewModel.send(.equipItem(item))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}

