//
//  ClosetView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import SwiftUI

struct ClosetView: View {
    @EnvironmentObject private var frogModel: FrogModel
    @StateObject private var closetViewModel: ClosetViewModel
    
    init(closetViewModel: ClosetViewModel) {
        self._closetViewModel = StateObject(wrappedValue: closetViewModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            if geo.size.width < geo.size.height {
                verticalContent(geo: geo)
            } else {
                horizontalContent(geo: geo)
            }
        }
        .navigationTitle(
            String(
                localized: "closetView.title",
                defaultValue: "Closet"
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(closetViewModel)
        .onAppear {
            closetViewModel.send(.equipItems(frogModel.items))
        }
        .onChange(of: frogModel.items) { newItems in
            closetViewModel.send(.equipItems(newItems))
        }
    }
    
    func verticalContent(geo: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            ClosetFrogView()
            
            ClosetItemTypeButtons()
                .padding(.horizontal, -16)
            
            Divider()
            
            ClosetItemGrid()
                .overlay(alignment: .bottom) {
                    
                    Button {
                        closetViewModel.send(.save)
                    } label: {
                        Text(
                            String(
                                localized: "closetView.save.button.title",
                                defaultValue: "Save current look"
                            )
                        )
                    }
                    .buttonStyle(
                        FQFilledButtonStyle(
                            disabled: frogModel.items == closetViewModel.currentEquippedItems
                        )
                    )
                }
            
        }
        .padding(.horizontal, 16)
      
    }
    
    func horizontalContent(geo: GeometryProxy) -> some View {
        HStack(spacing: 12) {
            ClosetFrogView()
            VStack(spacing: 12) {
                ClosetItemTypeButtons()
                    .padding(.horizontal, -16)
                
                Divider()
                
                ClosetItemGrid()
                    .overlay(alignment: .bottom) {
                        
                        Button {
                            closetViewModel.send(.save)
                        } label: {
                            Text(
                                String(
                                    localized: "closetView.save.button.title",
                                    defaultValue: "Save current look"
                                )
                            )
                        }
                        .buttonStyle(
                            FQFilledButtonStyle(
                                disabled: frogModel.items == closetViewModel.currentEquippedItems
                            )
                        )
                    }
            }
            
        }
        .padding(.horizontal, 16)
    }
}
