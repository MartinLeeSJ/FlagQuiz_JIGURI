//
//  StoreItemService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import Combine

protocol StoreItemServiceType {
    func getAllItemsOnStore(ofType: FQItemType) -> AnyPublisher<[FQItem], ServiceError>
    func buyItems(userId: String, items: [FQItem]) -> AnyPublisher<Void, ServiceError>
}

final class StoreItemService: StoreItemServiceType {
    func getAllItemsOnStore(ofType: FQItemType) -> AnyPublisher<[FQItem], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func buyItems(userId: String, items: [FQItem]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}

final class StubStoreItemService: StoreItemServiceType {
    func getAllItemsOnStore(ofType: FQItemType) -> AnyPublisher<[FQItem], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func buyItems(userId: String, items: [FQItem]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
