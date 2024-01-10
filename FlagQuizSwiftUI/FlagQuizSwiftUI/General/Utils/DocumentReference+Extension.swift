//
//  DocumentReference+Extension.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/9/24.
//

import Foundation
import Combine

import FirebaseFirestore

extension DocumentReference {
    func listenerPublisher<T: Decodable>(_ expecting: T?.Type) -> AnyPublisher<T?, Error> {
        let subject = CurrentValueSubject<T?, Error>(nil)
        
        let listener = addSnapshotListener { snapshot, error in
            if let error {
                subject.send(completion: .failure(error))
                return
            }
            
            guard let data = try? snapshot?.data(as: expecting) else {
                subject.send(nil)
                return
            }
            
            subject.send(data)
        }
        
        return subject.handleEvents(receiveCancel: {
            listener.remove()
        }).eraseToAnyPublisher()
    }
}
