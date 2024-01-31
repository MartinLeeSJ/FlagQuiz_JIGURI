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
            stockName: "Accessory1fullnameisverylong",
            names: [
                .init(languageCode: .EN, name: "Accessory1"),
                .init(languageCode: .KO, name: "악세서리1"),
            ],
            price: 100,
            specialPrice: 50,
            isOnEvent: false,
            isOnMarket: true
        ),
        .init(
            id: "112",
            type: .top,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "T-Shirt"),
                .init(languageCode: .KO, name: "티셔츠"),
            ],
            price: 200,
            specialPrice: 100,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "113",
            type: .accessory,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Accessory2"),
                .init(languageCode: .KO, name: "악세서리2"),
            ],
            price: 50,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: false
        ),
        .init(
            id: "114",
            type: .bottom,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Jeans"),
                .init(languageCode: .KO, name: "청바지"),
            ],
            price: 150,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        // Add more items as needed
        .init(
            id: "115",
            type: .accessory,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Sunglasses"),
                .init(languageCode: .KO, name: "선글라스"),
            ],
            price: 80,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "116",
            type: .overall,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Dress"),
                .init(languageCode: .KO, name: "드레스"),
            ],
            price: 300,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        
            .init(
                id: "117",
                type: .bottom,
                stockName: "T-Shirt",
                names: [
                    .init(languageCode: .EN, name: "Belt"),
                    .init(languageCode: .KO, name: "벨트"),
                ],
                price: 60,
                specialPrice: 50,
                isOnEvent: true,
                isOnMarket: true
            ),
        .init(
            id: "118",
            type: .top,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Jacket"),
                .init(languageCode: .KO, name: "자켓"),
            ],
            price: 250,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "119",
            type: .accessory,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Watch"),
                .init(languageCode: .KO, name: "시계"),
            ],
            price: 180,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "120",
            type: .gloves,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Mittle"),
                .init(languageCode: .KO, name: "손모아장갑"),
            ],
            price: 120,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "121",
            type: .hat,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Hat"),
                .init(languageCode: .KO, name: "모자"),
            ],
            price: 40,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "122",
            type: .hair,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Curly"),
                .init(languageCode: .KO, name: "곱슬머리"),
            ],
            price: 180,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "123",
            type: .faceDeco,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "blush"),
                .init(languageCode: .KO, name: "수줍음"),
            ],
            price: 30,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "124",
            type: .background,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Snowy Day"),
                .init(languageCode: .KO, name: "눈이와요"),
            ],
            price: 90,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "125",
            type: .set,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Winter pack"),
                .init(languageCode: .KO, name: "겨울 세트"),
            ],
            price: 70,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "126",
            type: .top,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Blouse"),
                .init(languageCode: .KO, name: "블라우스"),
            ],
            price: 150,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "127",
            type: .shoes,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "High hill"),
                .init(languageCode: .KO, name: "또각구두"),
            ],
            price: 25,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "128",
            type: .overall,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Denim Work Suit"),
                .init(languageCode: .KO, name: "데님 멜빵바지"),
            ],
            price: 350,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "129",
            type: .accessory,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Scarf"),
                .init(languageCode: .KO, name: "목도리"),
            ],
            price: 45,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        ),
        .init(
            id: "130",
            type: .overall,
            stockName: "T-Shirt",
            names: [
                .init(languageCode: .EN, name: "Suit"),
                .init(languageCode: .KO, name: "정장"),
            ],
            price: 600,
            specialPrice: 50,
            isOnEvent: true,
            isOnMarket: true
        )
    ]
    }
    
#endif
}
