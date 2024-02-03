//
//  ClosetView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import SwiftUI

struct ClosetView: View {
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
        .navigationBarBackButtonHidden()
        .environmentObject(closetViewModel)
        .toolbar {
            ToolbarItem {
                Button {
                    
                } label: {
                    Text("save and quit")
                }
            }
        }
    }
    
    func verticalContent(geo: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            ClosetFrogView()
            
            ClosetItemTypeButtons()
                .padding(.horizontal, -16)
            
            Divider()
            
            ClosetItemGrid()
            
        }
        .padding(.horizontal, 16)
        .overlay {
            
        }
    }
    
    func horizontalContent(geo: GeometryProxy) -> some View {
        Text("need")
    }
}

#Preview {
    NavigationStack {
        ClosetView(
            closetViewModel: .init(
                container: .init(
                    services: StubService()
                ), initialItems: []
            )
        )
    }
}
