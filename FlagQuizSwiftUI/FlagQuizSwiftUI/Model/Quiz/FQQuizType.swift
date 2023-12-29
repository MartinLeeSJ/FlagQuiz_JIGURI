//
//  FQQuizType.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation


enum FQQuizType: String, Hashable, CaseIterable {
    /// 국기를 보고 나라 이름을 맞추기
    case chooseNameFromFlag
    /// 나라 이름을 보고 국기를 맞추기
    case chooseFlagFromName
    /// 나라 이름을 보고 수도를 맞추기
    case chooseCaptialFromName
}
