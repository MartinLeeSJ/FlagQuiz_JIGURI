//
//  InformationViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/13/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class InformationViewModel: ObservableObject {
    @Published var infos: [FQInfo] = [] {
        didSet {
            withAnimation {
                self.pinnedInfo = infos.filter { $0.pinned }.first
            }
        }
    }
    @Published var pinnedInfo: FQInfo?
    
    private let db = Firestore.firestore()
    
    func load() async {
        do {
            self.infos = try await db.collection("Information")
                .order(by: "timestamp", descending: true)
                .getDocuments(as: FQInfo.self)
        } catch {
            // Erorr Handling
            print(error.localizedDescription)
        }
    }
}
