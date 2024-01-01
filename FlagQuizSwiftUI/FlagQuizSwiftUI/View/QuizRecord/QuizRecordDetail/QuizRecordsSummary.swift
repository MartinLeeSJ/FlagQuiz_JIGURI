//
//  QuizRecordsSummary.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/1/24.
//

import SwiftUI

struct QuizRecordsSummary: View {
    private let record: FQQuizRecord
    
    init(record: FQQuizRecord) {
        self.record = record
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            Spacer()
            VStack {
                Text("quiz.records.summary.submission.time.title")
                    .font(.headline)
                Spacer()
                
                Text(record.createdAt, style: .time)
                    .fontWeight(.medium)
                Spacer()
                Text(record.createdAt, style: .date)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            Divider()
            
            VStack {
                Text("quiz.records.summary.quiz.result.title")
                    .font(.headline)
                Spacer()
                record.score.classifiedScore.badge
                    .foregroundStyle(record.score.classifiedScore.tintColor)
                    .font(.largeTitle)
                
                Spacer()
                Text(record.score.scoreDescription)
                    .font(.caption)
                
            }
            
            Spacer()
        }
        .frame(maxHeight: 90)
    }
}
