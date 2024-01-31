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
    @Published var wearingItems: [FQItem] = []
    @Published var cart: Set<FQItem> = .init()
    @Published var toast: ToastAlert?
    
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case tryOn(item: FQItem, languageCode: String)
        case addItemToCart(item: FQItem, languageCode: String)
        case addWearingItemsToCart
    }
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func load() async {
        do {
            storeItems = try await container.services.storeItemService.getItems()
        } catch {
            toast = .init(
                style: .failed,
                message: Localized.cannotGetStoreItems
            )
        }
    }
    
    func send(_ action: Action) {
        switch action {
        case .tryOn(let item, let code):
            tryOn(item: item, languageCode: code)
            
        case .addItemToCart(let item, let code):
            addToCart(item: item, languageCode: code)
            
        case .addWearingItemsToCart:
            addWearingItemsToCart()
        }
    }
    
    
    //MARK: - Try on
    
    /// 지구리가 아이템을 착용할 때 실행하는 함수
    /// - Parameters:
    ///   - item: 착용하는 아이템
    ///   - code: 언어코드 <- 뷰에서 토스트를 띄우는 방향으로 리팩토링 필요해보임
    private func tryOn(item: FQItem, languageCode code: String) {
        // 만약 상하의를 입는 거라면 tryTopBottom(item:languageCode:)를 실행한다.
        guard item.type != .top || item.type != .bottom else {
            tryTopBottomOn(item: item, languageCode: code)
            return
        }
        
        // 만약 한벌 의상을 입는 거라면 tryTopBottom(item:languageCode:)를 실행한다.
        guard item.type == .overall else {
            tryOverAllOn(item: item, languageCode: code)
            return
        }
        
        
        // 입을 옷 종류가 현재 입고있는 옷 종류와 겹친다면 제거하고 입어준다.
        if let index = wearingItems.firstIndex(where: { $0.type == item.type }) {
            let takingOffItem: FQItem = wearingItems.remove(at: index)
            wearingItems.insert(item, at: index)
            
            toast = .init(
                message: Localized.changeCloth(
                    from: [ localizedItemName(of: takingOffItem, languageCode: code) ],
                    to: localizedItemName(of: item, languageCode: code)
                )
            )
            return
        }
        
        wearingItems.append(item)
    }
    
    
    /// 상 하의 종류의 아이템을 착용한다.
    /// 상 하의를 입을 때에는 이미 입고있는 상하의를 벗거나, 한 벌 의상을 벗어야한다.
    /// - Parameters:
    ///   - item: 착용할 아이템
    ///   - code: 언어코드
    private func tryTopBottomOn(item: FQItem, languageCode code: String) {
        var indexes: [Int] = .init()
        
        // 착용할 아이템이 착용하고 있는 아이템과 겹치거나, 한벌의상을 입고 있는 경우
        // 배열에 벗을 아이템을 담아주고 인덱스도 indexes에 저장한다.
        let takingOffItems = wearingItems.enumerated().compactMap { index, wearing in
            if (wearing.type == item.type) || (wearing.type == .overall) {
                indexes.append(index)
                return wearing
            }
            return nil
        }
        
        // 만약 벗어야하는 아이템이 없다면
        if takingOffItems.isEmpty {
            wearingItems.append(item)
            return
        }
        
        // 벗어야하는 아이템을 wearingItems에서 지우고 입을 아이템을 insert한다
        wearingItems.remove(atOffsets: IndexSet(indexes))
        wearingItems.insert(item, at: indexes.first ?? 0)
        
        toast = .init(
            message: Localized.changeCloth(
                from: takingOffItems.map { localizedItemName(of: $0, languageCode: code) },
                to: localizedItemName(of: item, languageCode: code)
            )
        )
    }
    
    
    /// 한 벌 의상을 착용한다.
    /// 한 벌 의상을 착용할 때 이미 입고 있는 한 벌의상을 벗거나, 상 하의를 벗어야한다.
    /// - Parameters:
    ///   - item: 착용할 아이템
    ///   - code: 언어코드
    private func tryOverAllOn(item: FQItem, languageCode code: String) {
        var indexes: [Int] = .init()
        
        // 이미 상의, 하의 또는 한 벌 의상을 입고 있는 경우 벗어야한다.
        // 배열에 벗을 아이템을 담아주고 인덱스도 indexes에 저장한다.
        let takingOffItems = wearingItems.enumerated().compactMap { index, wearing in
            let findingTypes: [FQItemType] = [.overall, .top, .bottom]
            
            if findingTypes.contains(where: { $0 == wearing.type }) {
                indexes.append(index)
                return wearing
            }
            return nil
        }
        
        // 벗을 아이템이 없을 경우 착용할 아이템을 입고 종료한다.
        if takingOffItems .isEmpty {
            wearingItems.append(item)
            return
        }
        
        // 벗어야하는 아이템을 wearingItems에서 지우고 입을 아이템을 insert한다
        wearingItems.remove(atOffsets: IndexSet(indexes))
        wearingItems.insert(item, at: indexes.first ?? 0)
        
        
        toast = .init(
            message: Localized.changeCloth(
                from: takingOffItems.map { localizedItemName(of: $0, languageCode: code) },
                to: localizedItemName(of: item, languageCode: code)
            )
        )
    }
    
    //MARK: - Add To Cart
    
    private func addToCart(item: FQItem, languageCode code: String) {
        cart.insert(item)
        
        toast = .init(
            message: Localized.addedToCart(
                item: localizedItemName(
                    of: item,
                    languageCode: code
                )
            )
        )
    }
    
    //MARK: - Add Wearings To Cart
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addWearingItemsToCart() {
        guard !wearingItems.isEmpty else { return }
        
        /// 이미 장바구니에 있는 착용하고 잇는 옷 개수
        let alreadyInCartItemCount: Int = Set(wearingItems).intersection(cart).count
        
        if alreadyInCartItemCount != 0 {
            /// 이미 장바구니에 있는 착용하고 잇는 옷이 있다면
            toast = .init(
                message: Localized.addedWearingsToTheCartExcept(
                    clothes: wearingItems.count - alreadyInCartItemCount
                )
            )
        } else {
            /// 장바구니에 있는 착용하고 잇는 옷이 없다면
            toast = .init(
                message: Localized.addedWearingsToTheCart(
                    clothes: wearingItems.count
                )
            )
        }
        
        /// 장바구니에 추가하기
        cart.formUnion(wearingItems)
    }
    
    private func localizedItemName(of item: FQItem, languageCode code: String) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: code) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
    
}

// MARK: - Localization

fileprivate struct Localized  {
    static var cannotGetStoreItems: String {
        String(
            localized: "toastAlert.cannot.get.store.items",
            defaultValue: "Can not get items"
        )
    }
    
    static func changeCloth(from: [String], to: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.change.cloth.from.\(from.joined(separator: ", ")).to.\(to)"
        )
    }
    
    static func addedToCart(item: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.added.to.cart.\(item)"
        )
    }
    
    static var addWearingsInTheCart: String {
        String(localized: "itemStoreView.add.wearings.in.the.cart.button.title")
    }
    
    static func addedWearingsToTheCart(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart")
    }
    
    
    static func addedWearingsToTheCartExcept(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart.except.already.exists")
    }
}
