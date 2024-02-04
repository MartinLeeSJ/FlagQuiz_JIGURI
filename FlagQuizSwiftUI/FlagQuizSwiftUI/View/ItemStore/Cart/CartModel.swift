//
//  CartModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI
import Combine

enum ItemStorePayingingState {
    case none
    case paying
    case success
    case failed
    case canNotAfford
}

final class CartModel: ObservableObject {
    @Published var items: [FQItem] = .init()
    @Published var payingState: ItemStorePayingingState = .none
    
    enum Action {
        case checkout(isFrogHappy: Bool)
        case addItemToTheCart(item: FQItem)
        case addTheTriedOnItemsToCart(items: [FQItem])
        case removeItem(FQItem)
        case reset
    }
    
    var totalPrice: Int {
        items.reduce(0) {
            $0 + ($1.isOnEvent ? $1.specialPrice : $1.price)
        }
    }
    
    var discountedPrice: Int {
        Int(Double(totalPrice) * (1 - Double(FrogState.frogInGreatMoodDiscountPercentPoint) / 100))
    }
    
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    
    public func send(_ action: Action) {
        switch action {
        case .checkout(let frogStateDiscount):
            checkout(applying: frogStateDiscount)
        case .addItemToTheCart(let item) :
            addToCart(item)
        case .addTheTriedOnItemsToCart(let items):
            addTheTriedOnItemsToCart(items)
        case .removeItem(let item):
            removeItem(item)
        case .reset:
            items = []
            payingState = .none
        }
    }
    
    private func removeItem(_ item: FQItem) {
        guard items.contains(item) else { return }
        
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    //MARK: - Add To Cart
    
    private func addToCart(_ item: FQItem) {
        items.append(item)
    }
    
    //MARK: - Add Wearings To Cart
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addTheTriedOnItemsToCart(_ wearingItems: [FQItem]) {
        guard !wearingItems.isEmpty else { return }
        
        let cartSet = Set<FQItem>(items)
        
        /// 장바구니에 추가하기
        items = Array(cartSet.union(wearingItems))
    }
    
    private func checkout(applying frogStateDiscount: Bool) {
        payingState = .paying
        
        guard let userId = container.services.authService.checkAuthenticationState() else {
            payingState = .failed
            return
        }
        
        let point: Int = frogStateDiscount ? discountedPrice : totalPrice
        
        container.services.earthCandyService.checkEarthCandyIsEnough(
            userId,
            needed: frogStateDiscount ? discountedPrice : totalPrice
        )
        .flatMap { [weak self] canAfford in
            guard let self else {
                return Fail<Bool, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
            }
            
            if !canAfford {
                return  Just(false).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
            }
            
            return continueCheckOutProcess(userId: userId, point: point)
        }
        .sink { [weak self] completion in
            if case .failure = completion {
                self?.payingState = .failed
            }
        } receiveValue: { [weak self] checkedOutWithEnoughEarthCandy in
            self?.payingState = checkedOutWithEnoughEarthCandy ? .success : .canNotAfford
        }
        .store(in: &cancellables)
    }
    
    
    private func continueCheckOutProcess(userId: String, point: Int) -> AnyPublisher<Bool, ServiceError> {
        self.container.services.userItemService.addUserItems(
            of: userId,
            items: items.map { $0.toUserItem() }
        )
        .flatMap { [weak self] _ in
            guard let self else {
                return Fail<Void, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
            }
            
            return self.container.services.earthCandyService.updateCandy(
                -point,
                ofUser: userId
            )
            .eraseToAnyPublisher()
        }
        .map { _ in true }
        .eraseToAnyPublisher()
    }
    
}
