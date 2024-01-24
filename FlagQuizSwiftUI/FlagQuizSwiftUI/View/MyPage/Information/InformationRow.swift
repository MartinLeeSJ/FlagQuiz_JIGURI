//
//  InformationRow.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/13/24.
//

import SwiftUI

struct PinnedInformation: View {
    private let info: FQInfo
    private let action: () -> Void
    
    init(
        info: FQInfo,
        action: @escaping () -> Void = {}
    ) {
        self.info = info
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(info.title)
                .font(.headline)
                .padding(.bottom , -12)
            
            Text(info.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom , -12)
            
            Text(info.createdAt, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(info.body.replacingOccurrences(of: "\\n", with: "\n"))
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .overlay(alignment: .bottomTrailing) {
                    moreButton
                }
        }
    }
    
    private var moreButton: some View {
            Button {
                action()
            } label: {
                Text("more.button.title")
                    .font(.system(size: 12))
                    .padding(.leading, 32)
            }
            .background(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .fqBg, location: 0.3)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

struct InformationRow: View {
    private let info: FQInfo
    private let action: () -> Void
    
    @State private var isExpanded: Bool = false
    @State private var shouldShowMoreButton: Bool = false
    
    init(
        info: FQInfo,
        action: @escaping () -> Void = {}
    ) {
        self.info = info
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(info.title)
                .font(.headline)
                .padding(.bottom , -12)
            
            Text(info.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom , -12)
            
            Text(info.createdAt, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(info.body.replacingOccurrences(of: "\\n", with: "\n"))
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(isExpanded ? nil : 2)
                .background {
                    GeometryReader { proxy in
                        Color.clear.onAppear {
                            determineShowingMoreButton(text: info.body, proxy)
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    if shouldShowMoreButton {
                        moreButton
                    }
                }
        }
    }
    
    private func determineShowingMoreButton(text: String, _ geometry: GeometryProxy) {
        let total = text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 12)],
            context: nil
        )
        
        self.shouldShowMoreButton = total.size.height > geometry.size.height
    }
    
    @ViewBuilder
    private var moreButton: some View {
        if !isExpanded {
            Button {
                isExpanded = true
            } label: {
                Text("more.button.title")
                    .font(.system(size: 12))
                    .padding(.leading, 32)
            }
            .background(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .fqBg, location: 0.3)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }
    
    
}
