//
//  EarthCandyView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import SwiftUI

struct EarthCandyView: View {
    @Environment(\.colorScheme) private var scheme
    
    @StateObject private var viewModel: EarthCandyViewModel
    @State private var showDetail: Bool = false
    
    init(viewModel: EarthCandyViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
                    FlowingText("\(point)")
                } else {
                    Text("0")
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            viewModel.load()
        }
        .frame(
            idealWidth: 120,
            maxWidth: 160
        )
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(Material.thick)
        }
        .padding(.vertical, 4)
        .onTapGesture {
            showDetail = true
        }
        .fullScreenCover(isPresented: $showDetail) {
            EarthCandyDetailView()
            
        }
        
    }
}

struct EarthCandyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button("dismiss") {
            dismiss()
        }
    }
}

#Preview {
    EarthCandyView(
        viewModel: .init(
            container: .init(
                services: StubService()
            )
        )
    )
}
