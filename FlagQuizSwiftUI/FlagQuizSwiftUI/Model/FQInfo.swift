//
//  FQInfo.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/13/24.
//

import Foundation
import FirebaseFirestore

struct FQInfo: Codable, Hashable {
    @DocumentID var id: String?
    let title: String
    let subtitle: String
    let body: String
    let pinned: Bool
    private let timestamp: Timestamp
    
    var createdAt: Date {
        timestamp.dateValue()
    }
    
    init(id: String? = nil, title: String, subtitle: String, body: String, pinned: Bool, timestamp: Timestamp) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.pinned = pinned
        self.timestamp = timestamp
    }
}

extension FQInfo {
    #if DEBUG
    static let pinnedMock: FQInfo = .init(
        title: "아이스 아메리카노",
        subtitle: "아이스 아메리카노 아이템은 100지구알사탕",
        body: "아이스 아메리카노 아이템이 추가 되었습니다!. 시원한 아이스 아메리카노를 지구리의 손에 쥐어져 보세요!!!!!!!!!!!!!!!!",
        pinned: true,
        timestamp: .init(date: .now)
    )
    
    static let mockShort: FQInfo = .init(
        title: "가나다라마바사",
        subtitle: "아자차카타파하",
        body: "에헤 에헤 에헤에헤에헤헤",
        pinned: false,
        timestamp: .init(date: .now)
    )
    
    static let mockLong: FQInfo = .init(
        title: "긴 글 공지입니다.",
        subtitle: "긴 글 공지 테스트 입니다.",
        body: """
대통령이 제1항의 기간내에 공포나 재의의 요구를 하지 아니한 때에도 그 법률안은 법률로서 확정된다. 헌법재판소에서 법률의 위헌결정, 탄핵의 결정,
정당해산의 결정 또는 헌법소원에 관한 인용결정을 할 때에는 재판관 6인 이상의 찬성이 있어야 한다. 군인은 현역을 면한 후가 아니면 국무위원으로 임명될 수 없다.

국가안전보장에 관련되는 대외정책·군사정책과 국내정책의 수립에 관하여 국무회의의 심의에 앞서 대통령의 자문에 응하기 위하여 국가안전보장회의를 둔다.
""",
        pinned: false,
        timestamp: .init(date: .now)
    )
    
    
    #endif
}
