//
//  FQItemObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import FirebaseFirestore

struct FQItemObject: Codable {
    @DocumentID var id: String?
    var type: String
    var stockName: String
    var names: [FQItemNameObject]
    var price: Int
    var specialPrice: Int
    var isOnEvent: Bool
    var isOnMarket: Bool
}

extension FQItemObject {
    func toModel() -> FQItem? {
        guard let id else {
            return nil
        }
        guard let type = FQItemType(rawValue: type) else {
            return nil
        } 
        
        return .init(
            id: id,
            type: type,
            stockName: stockName,
            names: names.map { $0.toModel() },
            price: price,
            specialPrice: specialPrice,
            isOnEvent: isOnEvent,
            isOnMarket: isOnMarket
        )
    }
    
    func nilIdObject() -> FQItemObject {
        .init(
            id: nil,
            type: type,
            stockName: stockName,
            names: names,
            price: price,
            specialPrice: specialPrice,
            isOnEvent: isOnEvent,
            isOnMarket: isOnMarket
        )
       
    }
}
