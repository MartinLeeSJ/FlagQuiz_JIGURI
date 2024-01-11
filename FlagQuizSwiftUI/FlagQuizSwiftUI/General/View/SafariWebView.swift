//
//  SafariWebView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/11/24.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
