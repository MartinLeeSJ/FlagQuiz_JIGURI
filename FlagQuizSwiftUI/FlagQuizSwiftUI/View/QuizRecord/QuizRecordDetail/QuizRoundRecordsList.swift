//
//  QuizRoundRecordsList.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/1/24.
//

import SwiftUI

struct QuizRoundRecordsList: View {
    @EnvironmentObject private var container: DIContainer
    @State private var presentedCountry: FQCountryISOCode?
    private let rounds: [FQQuizRoundRecord]
    
    init(rounds: [FQQuizRoundRecord]) {
        self.rounds = rounds
    }
    
    var body: some View {
        ForEach(rounds, id: \.self) { round in
            VStack(alignment: .leading, spacing: 12) {
                Text(round.quizType?.localizedShortenedTitle ?? "-")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(in: Capsule().stroke(lineWidth: 1))
                    .backgroundStyle(Color.accentColor)
                
                answerAndSubmisson(of: round)
                    
                quizOptions(round.optionsCountryCodes)
               
                Divider()
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func answerAndSubmisson(of round: FQQuizRoundRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("quiz.round.records.answer.title")
                        .font(.caption.bold())
                    flagLabel(of: round.answerCountryCode)
                }
                
                if let submittedCountryCode = round.submittedCountryCode,
                   round.answerCountryCode != submittedCountryCode {
                    HStack {
                        Text("quiz.round.records.submission.title")
                            .font(.caption.bold())
                        
                        flagLabel(of: submittedCountryCode)
                    }
                }
            }
            
            Spacer()
            
            if let submittedCountryCode = round.submittedCountryCode,
               round.answerCountryCode == submittedCountryCode {
                Image(systemName: "circle")
                    .foregroundStyle(.blue)
                    .imageScale(.large)
            } else {
                Image(systemName: "xmark")
                    .foregroundStyle(.red)
                    .imageScale(.large)
            }
            
        }
    }
    
    @ViewBuilder
    private func quizOptions(_ codes: [FQCountryISOCode]) -> some View {
        Text("quiz.round.records.quiz.options.title")
            .font(.caption.bold())
        
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(codes, id: \.self) { code in
                    flagLabel(of: code)
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, -16)
    }
    
    private func flagLabel(of countryCode: FQCountryISOCode) -> some View {
        Button {
            presentedCountry = countryCode
        } label: {
            HStack {
                Text(countryCode.flagEmoji ?? "-")
                Text(countryCode.localizedName ?? "-")
                    .font(.caption)
                    .foregroundStyle(.foreground)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .backgroundStyle(.thinMaterial)
            
        }
        .sheet(item: $presentedCountry) { countryCode in
            CountryDetailView(viewModel: .init(container: container, countryCode: countryCode))
        }
        
    }
}

