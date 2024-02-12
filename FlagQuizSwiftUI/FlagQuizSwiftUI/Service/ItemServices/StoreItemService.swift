//
//  StoreItemService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import Combine

protocol StoreItemServiceType {
    func getItems() async throws -> [FQItem]
}

final class StoreItemService: StoreItemServiceType {
    private let repository: StoreItemDBRepositoryType
    
    init(repository: StoreItemDBRepositoryType) {
        self.repository = repository
    }
    
    func getItems() async throws -> [FQItem] {
        let items = try await repository.getItems()
        return items.compactMap { $0?.toModel() }
    }
    
}

final class StubStoreItemService: StoreItemServiceType {
    func getItems() async throws -> [FQItem] {
        []
    }
}
