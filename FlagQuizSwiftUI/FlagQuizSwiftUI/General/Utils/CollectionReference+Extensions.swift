//
//  CollectionReference+Extensions.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import Combine
import FirebaseFirestore

extension CollectionReference {
    func listenPublisher<T: Decodable>(_ expecting: T.Type) -> AnyPublisher<[T]?, Error> {
        let subject = CurrentValueSubject<[T]?, Error>(nil)
        
        let listener = addSnapshotListener { snapshots, error in
            if let error {
                subject.send(completion: .failure(error))
                return
            }
            
            let data = snapshots?.documents.compactMap { snapshot in
                try? snapshot.data(as: expecting)
            }
            
            subject.send(data)
        }
        
        return subject.handleEvents(receiveCancel: {
            listener.remove()
        }).eraseToAnyPublisher()
    }
}


