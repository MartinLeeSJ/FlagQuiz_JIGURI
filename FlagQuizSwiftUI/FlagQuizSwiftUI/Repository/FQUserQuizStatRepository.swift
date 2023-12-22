//
//  FQUserQuizStatRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FQUserQuizStatRepositoryType {
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStatObject
    func addQuizStat(ofUser userId: String,
                     addingQuizCount quizCount: Int,
                     addingCorrectQuizCount correctCount: Int) async throws
    
}

final class FQUserQuizStatRepository: FQUserQuizStatRepositoryType {
    
    private let db = Firestore.firestore()
    
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStatObject {
        
        let docRef = db.collection(CollectionKey.UserQuizStats).document(userId)
        
        let object = try await docRef.getDocument(as: FQUserQuizStatObject.self)
        
        return object
    }
    
    func addQuizStat(ofUser userId: String,
                     addingQuizCount quizCount: Int,
                     addingCorrectQuizCount correctCount: Int) async throws {
        
        let docRef = db.collection(CollectionKey.UserQuizStats).document(userId)
        
        if var object = try? await docRef.getDocument(as: FQUserQuizStatObject.self) {
            object.countryQuizCount += quizCount
            object.correctCountryQuizCount += correctCount
            object.lastUpdated = .init(date: .now)
            try docRef.setData(from: object)
            return
        }
        
        try docRef.setData(from: FQUserQuizStatObject(correctCountryQuizCount: correctCount,
                                                      countryQuizCount: quizCount))
    }
    
   
}
