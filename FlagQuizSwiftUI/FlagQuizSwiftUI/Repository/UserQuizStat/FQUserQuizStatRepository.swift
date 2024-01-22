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
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStatObject?
    func addQuizStat(quizStat model: FQUserQuizStat) async throws
    func deleteQuizStat(ofUser userId: String) async throws
}

final class FQUserQuizStatRepository: FQUserQuizStatRepositoryType {
    
    private let db = Firestore.firestore()
    
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStatObject? {
        
        let docRef = db.collection(CollectionKey.UserQuizStats).document(userId)
        
        let object = try await docRef.getDocument(as: FQUserQuizStatObject?.self)
        
        return object
    }
    
    // TODO: - 분명 더 나은 방법이 있을 것 같음
    func addQuizStat(quizStat model: FQUserQuizStat) async throws {
        
        let docRef = db.collection(CollectionKey.UserQuizStats).document(model.userId)
        
        if var object = try? await docRef.getDocument(as: FQUserQuizStatObject.self) {

            object.capitalQuizCount = (object.capitalQuizCount ?? 0) + (model.capitalQuizCount ?? 0)
            object.correctCapitalQuizCount = (object.correctCapitalQuizCount ?? 0) + (model.correctCapitalQuizCount ?? 0)
            
            object.flagToNameQuizCount = (object.flagToNameQuizCount ?? 0) + (model.flagToNameQuizCount ?? 0)
            object.correctFlagToNameQuizCount = (object.correctFlagToNameQuizCount ?? 0) + (model.correctFlagToNameQuizCount ?? 0)
            
            object.nameToFlagQuizCount = (object.nameToFlagQuizCount ?? 0) + (model.nameToFlagQuizCount ?? 0)
            object.correctNameToFlagQuizCount = (object.correctNameToFlagQuizCount ?? 0) + (model.correctNameToFlagQuizCount ?? 0)
            
            object.lastUpdated = .init(date: .now)
            try docRef.setData(from: object)
            return
        }
        
        try docRef.setData(
            from: 
                FQUserQuizStatObject(
                correctCaptialQuizCount: model.correctCapitalQuizCount,
                captialQuizCount: model.correctCapitalQuizCount,
                correctFlagToNameQuizCount: model.correctFlagToNameQuizCount,
                flagToNameQuizCount: model.flagToNameQuizCount,
                correctNameToFlagQuizCount: model.correctNameToFlagQuizCount,
                nameToFlagQuizCount: model.nameToFlagQuizCount,
                lastUpdated: .init(date: .now)
            )
        )
    }
    
    func deleteQuizStat(ofUser userId: String) async throws {
        let docRef = db.collection(CollectionKey.UserQuizStats).document(userId)
        try await docRef.delete()
    }
   
}
