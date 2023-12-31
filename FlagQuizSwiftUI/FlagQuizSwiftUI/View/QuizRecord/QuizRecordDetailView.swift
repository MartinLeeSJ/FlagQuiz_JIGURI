//
//  QuizRecordDetailView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import SwiftUI


struct QuizRecordDetailView: View {
    private let record: FQQuizRecord
    
    init(record: FQQuizRecord) {
        self.record = record
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    QuizRecordDetailView(
        record: .init(
            quizCount: 1,
            quizOptionsCount: 4,
            quizRounds: [.init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                optionsCountryCodes: [],
                quizType: .chooseFlagFromName
            )],
            createdAt: .now
        )
    )
}
