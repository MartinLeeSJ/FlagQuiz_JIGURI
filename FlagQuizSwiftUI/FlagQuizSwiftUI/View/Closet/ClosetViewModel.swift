//
//  ClosetViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import Foundation
import Combine

final class ClosetViewModel: ObservableObject {
    @Published var selectedType: FQItemType = .hair
    @Published var itemsOfType: [FQItemType:[FQUserItem]] = .init()
    @Published var equippedItem: [FQItemType: FQUserItem?] = .init() {
        didSet {
            currentEquippedItems = equippedItem.values.compactMap { $0 }
        }
    }
    @Published var currentEquippedItems: [FQUserItem] = []
    
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case selectType(FQItemType)
        case equipItem(FQUserItem)
        case equipItems([FQUserItem])
        case takeOffItem(FQItemType)
        case save
    }
    
    init(
        container: DIContainer
    ) {
        self.container = container
        load()
    }
    
    func send(_ action: Action) {
        switch action {
        case .selectType(let type):
            selectedType = type
        case .equipItem(let item) :
            equipItem(item)
        case .equipItems(let items):
            items.forEach { equippedItem[$0.type] = $0 }
        case .takeOffItem(let type):
            equippedItem[type] = nil
        case .save:
            save()
        }
    }
    
    func load() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        $selectedType
            .flatMap { [weak self] type in
                guard let self else {
                    return Fail<[FQUserItem], ServiceError>(error: .nilSelf).eraseToAnyPublisher()
                }
                
                if let items = itemsOfType[type] {
                    return Just(items).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                }
                               
                return container.services.userItemService.getUserItems(ofUser: userId, ofType: type)
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                //TODO: Error Handling
                
            } receiveValue: { [weak self] items in
                if let type = items.first?.type {
                    self?.itemsOfType[type] = items
                }
            }
            .store(in: &cancellables)
    }
    
    private func equipItem(_ item: FQUserItem) {
        defer {
            equippedItem[item.type] = item
        }
        
        switch item.type {
        case .top, .bottom:
            equippedItem[.overall] = nil
        case .overall:
            equippedItem[.top] = nil
            equippedItem[.bottom] = nil
        case .set:
            equippedItem = .init()
        default:
            break
        }
        
    }
    
    
    private func save() {
        let items: [FQUserItem] = equippedItem.values.compactMap { $0 }
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        
        container.services.frogService.updateFrogItems(ofUser: userId, itemIds: items.map { $0.id } )
            .sink { _ in
                
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

    }

    
}
