//
//  EarthCandyView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import SwiftUI

struct EarthCandyView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: EarthCandyViewModel
    
    @State private var showDetail: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image("EarthCandy")
                .resizable()
                .scaledToFit()
                .padding(8)
                .shadow(
                    color: scheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5) ,
                    radius: scheme == .dark ? 5 : 1
                )
            
            Group {
                if let point = viewModel.earthCandy?.point {
                    Text(point, format: .number)
                } else {
                    Text("0")
                    
                }
            }
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(.medium)
            
            Image(systemName: "plus", variableValue: 0.5)
                .font(.caption)
                .fontWeight(.black)
                .padding(.trailing, 8)
        }
        .task {
            viewModel.observe()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .onTapGesture {
            showDetail = true
        }
        .fullScreenCover(isPresented: $showDetail) {
            EarthCandyRewardView(viewModel: .init(container: container))
            
        }
        
    }
}



#Preview {
    let container = DIContainer(services: StubService())
    return EarthCandyView()
        .environmentObject(
            EarthCandyViewModel(
              container: container
            )
        )
        .environmentObject(container)
}
