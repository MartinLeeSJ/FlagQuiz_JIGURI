//
//  AskToView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/14/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct AskToView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var isPresented: Bool = false
    @State private var offset: CGFloat = 0
    @State private var workItem: DispatchWorkItem?
    @State private var toast: ToastAlert? = nil
    
    private let mail: String = "nomadmeta.company@gmail.com"
    
    var body: some View {
        VStack {
            Spacer()
            Text(mail)
                .font(.custom(FontName.pixel, size: 24))
                .foregroundStyle(.fqAccent)
            Text("askToView.tap.twice.instuction")
                .font(.caption)
            Spacer()
        }
        .onTapGesture(count: 2) {
            UIPasteboard.general.setValue(
                mail,
                forPasteboardType: UTType.plainText.identifier
            )
            toast = ToastAlert(message: String(localized: "askToView.copy.completed"))
        }
        .toastAlert($toast)
        
    }
}

#Preview {
    AskToView()
}
