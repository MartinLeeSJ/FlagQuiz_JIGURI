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
    var names: [FQItemNameObject]
    var price: Int
    var isOnMarket: Bool
    var imageUrl: String?
    var storeImageUrl: String?
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
            names: names.map { $0.toModel() },
            price: price,
            isOnMarket: isOnMarket,
            imageUrl: imageUrl,
            storeImageUrl: storeImageUrl
        )
    }
    
    func nilIdObject() -> FQItemObject {
        .init(
            id: nil,
            type: type,
            names: names,
            price: price,
            isOnMarket: isOnMarket,
            imageUrl: imageUrl,
            storeImageUrl: storeImageUrl
        )
       
    }
}
