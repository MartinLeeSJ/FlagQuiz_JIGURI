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
            toast()
        }
        .overlay(alignment: .bottom) {
            if isPresented {
                Text("askToView.copy.completed")
                    .font(.callout)
                    .foregroundStyle(scheme == .dark ? .black : .white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .backgroundStyle(scheme == .dark ? .white : .black)
                    .padding(.bottom)
                    .offset(y: offset)
                    .animation(.spring, value: offset)
            }
        }
    }
    
    private func toast() {
        UIImpactFeedbackGenerator(style: .light)
              .impactOccurred()
        
        workItem?.cancel()
        isPresented = true
        offset = .zero
       
        let task = DispatchWorkItem {
               dismissToast()
        }
             
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            offset = -20
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }
    
    private func dismissToast() {
        isPresented = false
        workItem?.cancel()
        workItem = nil
      }
    
    
}

#Preview {
    AskToView()
}
