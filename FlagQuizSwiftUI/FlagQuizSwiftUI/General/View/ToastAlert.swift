//
//  ToastAlert.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/21/24.
//

import SwiftUI

struct ToastAlert: Equatable {
    let style: ToastAlertStyle
    let message: String
    let duration: Double
    let width: CGFloat
    
    init(
        style: ToastAlertStyle = .success,
        message: String,
        duration: Double = 3,
        width: CGFloat = .infinity
    ) {
        self.style = style
        self.message = message
        self.duration = duration
        self.width = width
    }
}

enum ToastAlertStyle: String, Hashable {
    case success
    case failed
    
    var alertColor: Color {
        switch self {
        case .success: Color.fqAccent
        case .failed: Color.red
        }
    }
    
}

fileprivate struct ToastAlertView: View {
    @Environment(\.colorScheme) private var scheme
    
    private let style: ToastAlertStyle
    private let message: String
    private let width: CGFloat
    
    init(
        style: ToastAlertStyle,
        message: String,
        width: CGFloat
    ) {
        self.style = style
        self.message = message
        self.width = width
    }
    
    var body: some View {
        Text(message)
            .font(.callout)
            .padding()
            .frame(width: width)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.background)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style.alertColor, lineWidth: 2)
            }
            .padding(.horizontal)
    }
}

fileprivate struct ToastModifier: ViewModifier {
    @Binding var toast: ToastAlert?
    @State private var workItem: DispatchWorkItem?
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                toastView()
                    .animation(.spring(), value: toast)
            }
            .onChange(of: toast) { _ in
                showToast()
            }
        
    }
    
    @ViewBuilder
    private func toastView() -> some View {
        if let toast {
            VStack {
                Spacer()
                    
                ToastAlertView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                )
                .offset(y: offset)
                .animation(.spring, value: offset)
                .animation(.easeInOut, value: toast)
                
                Spacer()
                    .frame(height: 32)
            }
        }
    }
    
    private func showToast() {
        guard let toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
             .impactOccurred()
        
        offset = .zero
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                offset = -40
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
            
        }
        
    }
    
    private func dismissToast() {
        toast = nil
        offset = .zero
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastAlert(_ toast: Binding<ToastAlert?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
