//
//  QuizRecordViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation
import FirebaseFirestore

@MainActor
final class QuizRecordViewModel: ObservableObject {
    @Published var quizRecords: [FQQuizRecord] = []
    @Published var loadCount: Int = 0
    @Published var loadingState: LoadingState = .none
    
    enum LoadingState {
        case none
        case loading
        case finished
        case failure
    }
    
    private let container: DIContainer
    private let loadingCount: Int = 25
    private let loadCountLimit: Int = 4
    private var lastDocument: DocumentSnapshot?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func load() async {
        guard loadCount < loadCountLimit else { return }
        guard loadingState == .none else { return }
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        
        let recordService = container.services.quizRecordService
        loadingState = .loading
        
        do {
            let result = try await recordService.getQuizRecords(
                ofUser: userId,
                count: loadingCount,
                startAt: lastDocument
            )
            

            quizRecords.append(contentsOf: result.documents)
            loadCount += 1

            
            lastDocument = result.lastDocument
            loadingState = result.documents.count == loadingCount ? .none : .finished 
        } catch {
            loadingState = .failure
        }
    }

}
