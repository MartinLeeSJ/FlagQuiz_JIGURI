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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                Spacer()
                    .frame(height: 32)
                
                QuizRecordsSummary(record: record)
                
                QuizRecordsByTypeBanner(record: record)
                    .padding(.horizontal, 32)
                
                Divider()
                
                QuizRoundRecordsList(rounds: record.quizRounds)
            }
        }
    }
}


#Preview {
    QuizRecordDetailView(
        record: .init(
            quizCount: 2,
            quizOptionsCount: 4,
            quizRounds: [
                .init(
                    answerCountryCode: .init("170"),
                    submittedCountryCode: .init("170"),
                    optionsCountryCodes: [
                        .init("064"),
                        .init("068"),
                        .init("535"),
                        .init("170")
                    ],
                    quizType: .chooseFlagFromName
                ),
                .init(
                    answerCountryCode: .init("442"),
                    submittedCountryCode: .init("442"),
                    optionsCountryCodes: [
                        .init("434"),
                        .init("438"),
                        .init("440"),
                        .init("442")
                    ],
                    quizType: .chooseNameFromFlag
                )
            ],
            createdAt: .now
        )
    )
}
