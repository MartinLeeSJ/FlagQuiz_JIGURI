//
//  FQItem+Preview.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation

extension FQItem {
#if DEBUG
    static var mockItems: [FQItem] { [
        .init(
            id: "111",
            type: .accessory,
            names: [
                .init(languageCode: .EN, name: "Accessory1"),
                .init(languageCode: .KO, name: "악세서리1"),
            ],
            price: 100,
            isOnMarket: true
        ),
        .init(
            id: "112",
            type: .top,
            names: [
                .init(languageCode: .EN, name: "T-Shirt"),
                .init(languageCode: .KO, name: "티셔츠"),
            ],
            price: 200,
            isOnMarket: true
        ),
        .init(
            id: "113",
            type: .accessory,
            names: [
                .init(languageCode: .EN, name: "Accessory2"),
                .init(languageCode: .KO, name: "악세서리2"),
            ],
            price: 50,
            isOnMarket: false
        ),
        .init(
            id: "114",
            type: .bottom,
            names: [
                .init(languageCode: .EN, name: "Jeans"),
                .init(languageCode: .KO, name: "청바지"),
            ],
            price: 150,
            isOnMarket: true
        ),
        // Add more items as needed
        .init(
            id: "115",
            type: .accessory,
            names: [
                .init(languageCode: .EN, name: "Sunglasses"),
                .init(languageCode: .KO, name: "선글라스"),
            ],
            price: 80,
            isOnMarket: true
        ),
        .init(
            id: "116",
            type: .overall,
            names: [
                .init(languageCode: .EN, name: "Dress"),
                .init(languageCode: .KO, name: "드레스"),
            ],
            price: 300,
            isOnMarket: true
        ),
        
            .init(
                id: "117",
                type: .bottom,
                names: [
                    .init(languageCode: .EN, name: "Belt"),
                    .init(languageCode: .KO, name: "벨트"),
                ],
                price: 60,
                isOnMarket: true
            ),
        .init(
            id: "118",
            type: .top,
            names: [
                .init(languageCode: .EN, name: "Jacket"),
                .init(languageCode: .KO, name: "자켓"),
            ],
            price: 250,
            isOnMarket: true
        ),
        .init(
            id: "119",
            type: .accessory,
            names: [
                .init(languageCode: .EN, name: "Watch"),
                .init(languageCode: .KO, name: "시계"),
            ],
            price: 180,
            isOnMarket: true
        ),
        .init(
            id: "120",
            type: .gloves,
            names: [
                .init(languageCode: .EN, name: "Mittle"),
                .init(languageCode: .KO, name: "손모아장갑"),
            ],
            price: 120,
            isOnMarket: true
        ),
        .init(
            id: "121",
            type: .hat,
            names: [
                .init(languageCode: .EN, name: "Hat"),
                .init(languageCode: .KO, name: "모자"),
            ],
            price: 40,
            isOnMarket: true
        ),
        .init(
            id: "122",
            type: .hair,
            names: [
                .init(languageCode: .EN, name: "Curly"),
                .init(languageCode: .KO, name: "곱슬머리"),
            ],
            price: 180,
            isOnMarket: true
        ),
        .init(
            id: "123",
            type: .faceDeco,
            names: [
                .init(languageCode: .EN, name: "blush"),
                .init(languageCode: .KO, name: "수줍음"),
            ],
            price: 30,
            isOnMarket: true
        ),
        .init(
            id: "124",
            type: .background,
            names: [
                .init(languageCode: .EN, name: "Snowy Day"),
                .init(languageCode: .KO, name: "눈이와요"),
            ],
            price: 90,
            isOnMarket: true
        ),
        .init(
            id: "125",
            type: .set,
            names: [
                .init(languageCode: .EN, name: "Winter pack"),
                .init(languageCode: .KO, name: "겨울 세트"),
            ],
            price: 70,
            isOnMarket: true
        ),
        .init(
            id: "126",
            type: .top,
            names: [
                .init(languageCode: .EN, name: "Blouse"),
                .init(languageCode: .KO, name: "블라우스"),
            ],
            price: 150,
            isOnMarket: true
        ),
        .init(
            id: "127",
            type: .shoes,
            names: [
                .init(languageCode: .EN, name: "High hill"),
                .init(languageCode: .KO, name: "또각구두"),
            ],
            price: 25,
            isOnMarket: true
        ),
        .init(
            id: "128",
            type: .overall,
            names: [
                .init(languageCode: .EN, name: "Denim Work Suit"),
                .init(languageCode: .KO, name: "데님 멜빵바지"),
            ],
            price: 350,
            isOnMarket: true
        ),
        .init(
            id: "129",
            type: .accessory,
            names: [
                .init(languageCode: .EN, name: "Scarf"),
                .init(languageCode: .KO, name: "목도리"),
            ],
            price: 45,
            isOnMarket: true
        ),
        .init(
            id: "130",
            type: .overall,
            names: [
                .init(languageCode: .EN, name: "Suit"),
                .init(languageCode: .KO, name: "정장"),
            ],
            price: 600,
            isOnMarket: true
        )
    ]
    }
    
#endif
}
