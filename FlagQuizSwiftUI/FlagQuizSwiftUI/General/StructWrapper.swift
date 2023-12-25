//
//  StructWrapper.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/25/23.
//

import Foundation


class StructWrapper<T>: NSObject {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}
