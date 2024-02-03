//
//  ItemStoreViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/31/24.
//

import Foundation
import Combine

@MainActor
final class ItemStoreViewModel: ObservableObject {
    @Published var storeItems: [FQItem] = []
    @Published var selectedType: FQItemType? = .hair 
    @Published var triedOnItems: [FQItem] = []
    
    private let container: DIContainer
    
    enum Action {
        case selectType(type: FQItemType)
        case tryOn(item: FQItem)
        case takeOff(item: FQItem)
    }
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func load() async throws {
        storeItems = try await container.services.storeItemService.getItems()
    }
    
    func send(_ action: Action) {
        switch action {
        case .selectType(let type):
            selectedType = type
            
        case .tryOn(let item):
            tryOn(item: item)
            
        case .takeOff(let item):
            if let index = triedOnItems.firstIndex(of: item) {
                triedOnItems.remove(at: index)
            }
        }
    }
    
    
    //MARK: - Try on
    
    /// 중복된 카테고리의 옷이 있는지 확인하는 함수
    static func hasAnyDuplicateOrRelevantCategoryInTheTriedOnItem(
        triedOnItems: [FQItem],
        _ item: FQItem
    ) -> Bool {
        guard !triedOnItems.contains(where: {$0.type == item.type}) else {
            return true
        }
        
        switch item.type {
        case .top, .bottom:
            return triedOnItems.contains(where: {$0.type == .overall})
        case .overall:
            return triedOnItems.contains(where: {$0.type == .top || $0.type == .bottom})
        default:
            return false
        }
    }
    
    /// 지구리가 아이템을 착용할 때 실행하는 함수
    /// - Parameters:
    ///   - item: 착용하는 아이템
    private func tryOn(item: FQItem) {
        // 만약 상하의를 입는 거라면 tryTopBottom(item:languageCode:)를 실행한다.
        if item.type == .top || item.type == .bottom {
            tryTopBottomOn(item: item)
            return
        }
        
        // 만약 한벌 의상을 입는 거라면 tryTopBottom(item:languageCode:)를 실행한다.
        if item.type == .overall {
            tryOverAllOn(item: item)
            return
        }
        
        
        // 입을 옷 종류가 현재 입고있는 옷 종류와 겹친다면 제거하고 입어준다.
        if let index = triedOnItems.firstIndex(where: { $0.type == item.type }) {
            triedOnItems.remove(at: index)
            triedOnItems.insert(item, at: index)
            return
        }
        
        triedOnItems.append(item)
    }
    
    
    /// 상 하의 종류의 아이템을 착용한다.
    /// 상 하의를 입을 때에는 이미 입고있는 상하의를 벗거나, 한 벌 의상을 벗어야한다.
    /// - Parameters:
    ///   - item: 착용할 아이템
    private func tryTopBottomOn(item: FQItem) {
        var indexes: [Int] = .init()
        
        // 착용할 아이템이 착용하고 있는 아이템과 겹치거나, 한벌의상을 입고 있는 경우
        // 배열에 벗을 아이템을 담아주고 인덱스도 indexes에 저장한다.
        let takingOffItems = triedOnItems.enumerated().compactMap { index, wearing in
            if (wearing.type == item.type) || (wearing.type == .overall) {
                indexes.append(index)
                return wearing
            }
            return nil
        }
        
        // 만약 벗어야하는 아이템이 없다면
        if takingOffItems.isEmpty {
            triedOnItems.append(item)
            return
        }
        
        // 벗어야하는 아이템을 wearingItems에서 지우고 입을 아이템을 insert한다
        triedOnItems.remove(atOffsets: IndexSet(indexes))
        triedOnItems.insert(item, at: indexes.first ?? 0)
    }
    
    
    /// 한 벌 의상을 착용한다.
    /// 한 벌 의상을 착용할 때 이미 입고 있는 한 벌의상을 벗거나, 상 하의를 벗어야한다.
    /// - Parameters:
    ///   - item: 착용할 아이템
    private func tryOverAllOn(item: FQItem) {
        var indexes: [Int] = .init()
        
        // 이미 상의, 하의 또는 한 벌 의상을 입고 있는 경우 벗어야한다.
        // 배열에 벗을 아이템을 담아주고 인덱스도 indexes에 저장한다.
        let takingOffItems = triedOnItems.enumerated().compactMap { index, wearing in
            let findingTypes: [FQItemType] = [.overall, .top, .bottom]
            
            if findingTypes.contains(where: { $0 == wearing.type }) {
                indexes.append(index)
                return wearing
            }
            return nil
        }
        
        // 벗을 아이템이 없을 경우 착용할 아이템을 입고 종료한다.
        if takingOffItems .isEmpty {
            triedOnItems.append(item)
            return
        }
        
        // 벗어야하는 아이템을 wearingItems에서 지우고 입을 아이템을 insert한다
        triedOnItems.remove(atOffsets: IndexSet(indexes))
        triedOnItems.insert(item, at: indexes.first ?? 0)
    }
    
    //MARK: - Take Off
    
    private func takeOff(_ item: FQItem) {
        if let index = triedOnItems.firstIndex(where: { $0 == item }) {
            triedOnItems.remove(at: index)
        }
    }
    
}
