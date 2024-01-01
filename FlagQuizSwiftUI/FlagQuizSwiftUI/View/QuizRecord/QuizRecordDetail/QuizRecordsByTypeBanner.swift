//
//  QuizRecordsByTypeBanner.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/1/24.
//

import SwiftUI

struct QuizRecordsByTypeBanner: View {
   private let record: FQQuizRecord
   
   init(record: FQQuizRecord) {
       self.record = record
   }
   
   var body: some View {
       HStack {
           ForEach(
               FQQuizType.allCases.filter({ $0 != .random }),
               id: \.self
           ) { quizType in
               VStack(spacing: 16) {
                   Text(quizType.localizedShortenedTitle)
                       .font(.caption)
                       .fontWeight(.medium)
                       .padding(.bottom, -8)
                   
                   Divider()
                   
                   Text(record.quizResultByType(quizType))
                       .font(.caption2)
               }
               .padding([.horizontal, .top], 8)
               .padding(.bottom, 16)
               .background(
                   .thinMaterial,
                   in: RoundedRectangle(cornerRadius: 8, style: .continuous)
               )
               
           }
           
       }
       
   }
}
