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
                portraitContent(geo: geo)
            } else {
                landscapeContent(geo: geo)
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
    
    private func portraitContent(geo: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            ClosetFrogView()
            
            ClosetItemTypeButtons()
                .padding(.horizontal, -16)
            
            Divider()
            
            closetItemGrid(isLandscape: false)
            
        }
        .padding(.horizontal, 16)
      
    }
    
    private func landscapeContent(geo: GeometryProxy) -> some View {
        HStack(spacing: 12) {
            ClosetFrogView()
            VStack(spacing: 12) {
                ClosetItemTypeButtons()
                    .padding(.horizontal, -16)
                
                Divider()
                
               closetItemGrid(isLandscape: true)
            }
            
        }
        .padding(.horizontal, 16)
    }
    
    private func closetItemGrid(isLandscape: Bool) -> some View {
        ClosetItemGrid(isLandscape: isLandscape)
            .overlay(alignment: .bottom) {
                saveButton
            }
    }
    
    private var saveButton: some View {
        let didNotChanged: Bool = Set(frogModel.items) == Set(closetViewModel.currentEquippedItems)
        return  Button {
            closetViewModel.send(.save)
        } label: {
            Text(
                String(
                    localized: "closetView.save.button.title",
                    defaultValue: "Save current look"
                )
            )
        }
        .disabled(didNotChanged)
        .buttonStyle(
            FQFilledButtonStyle(
                disabled: didNotChanged
            )
        )
    }
}
