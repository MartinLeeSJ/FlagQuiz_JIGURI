//
//  Firestore+Extension.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getDocuments<T>(as: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshot(as: T.self).documents
    }
    
    func getDocumentsWithSnapshot<T>(
        as: T.Type
    ) async throws -> (documents: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        return (snapshot.documents.compactMap { try? $0.data(as: T.self) }, snapshot.documents.last)
    }
}
