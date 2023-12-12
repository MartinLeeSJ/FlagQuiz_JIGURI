//
//  ErrorView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct ErrorView: View {
    private let onReloadButtonTapped: () -> Void
    
    init(onReloadButtonTapped: @escaping () -> Void) {
        self.onReloadButtonTapped = onReloadButtonTapped
    }
    
    var body: some View {
        VStack {
            Text("ErrorView")
            Button {
                onReloadButtonTapped()
            } label: {
                Text("다시 로드")
            }
        }
    }
}

#Preview {
    ErrorView {
        print("Hello")
    }
}
