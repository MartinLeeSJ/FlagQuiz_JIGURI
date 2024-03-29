//
//  QuizResultScoreCard.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/7/24.
//

import SwiftUI

struct QuizResultScoreCard: View {
    @Environment(\.colorScheme) private var scheme
    @Binding private var showScoreDetail: Bool
    private let quizResult: FQQuiz
    private let quizScore: FQQuizScore
    private var scoreAnimation: Namespace.ID
    
    init(
        showScoreDetail: Binding<Bool>,
        quizResult: FQQuiz,
        quizScore: FQQuizScore,
        scoreAnimation: Namespace.ID
    ) {
        self._showScoreDetail = showScoreDetail
        self.quizResult = quizResult
        self.quizScore = quizScore
        self.scoreAnimation = scoreAnimation
    }
    
   
    
    private var estimatedCandy: Int {
        return FQEarthCandy.calculatePoint(from: quizResult, ofUser: "").point
    }
    
    var body: some View {
        VStack {
            Spacer()
            card
            Spacer()
            Button {
                withAnimation(.easeInOut) {
                    showScoreDetail = false
                }
            } label: {
                Text("show.result.button.title")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .fontWeight(.medium)
                    .foregroundStyle(scheme == .dark ? .black : .fqAccent)
                    .background(in: .capsule(style: .continuous))
                    .backgroundStyle(scheme == .dark ? .fqAccent : .black)
            }
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden()
    }
    
    var card: some View {
        VStack(alignment: .leading) {
            quizScore.classifiedScore.badge
                .resizable()
                .foregroundStyle(
                    .white,
                    quizScore.classifiedScore.tintColor
                )
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.badge,
                    in: scoreAnimation
                )
                .scaledToFit()
                .frame(minHeight: 30, maxHeight: 90)
                .frame(maxWidth: .infinity)
                .shadow(
                    color: quizScore.classifiedScore.tintColor.opacity(0.5),
                    radius: 15,
                    y: 10
                )
                .padding(.vertical, 16)
            
            
            Text("\(quizResult.correctQuizRoundsCount).out.of.\(quizResult.quizCount.rawValue).problems")
                .font(.subheadline)
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.description,
                    in: scoreAnimation
                )
            
            Text(quizScore.classifiedScore.description)
                .font(.title3.bold())
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.classifiedScoreDescription,
                    in: scoreAnimation
                )
            
            
            
            Divider()
            
            HStack(spacing: 0) {
                Text("you.have.got")
                    .font(.subheadline)
                    .padding(.trailing, 4)
                
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .padding(.trailing, 2)
                
                Text(estimatedCandy, format: .number)
            }
            .fontWeight(.medium)
            .matchedGeometryEffect(
                id: QuizResultViewAnimationID.earthCandy,
                in: scoreAnimation
            )
            
            earthCandyRecipt
        }
        .floatingCard()
    }
    
    
    @ViewBuilder
    private var earthCandyRecipt: some View {
        HStack {
            Text("correct.quiz.count")
                .font(.caption)
            Spacer()
            Text(quizResult.correctQuizRoundsCount, format: .number)
                .font(.callout)
        }

        HStack {
            Text("quizResultScoreCard.quizOptionsCount.advantage.point")
                .font(.caption)
            Spacer()
            Image(systemName: "plus")
                .font(.caption)
            Text(quizResult.quizOptionsCount.advantageCandy, format: .number)
                .font(.callout)
                .frame(width: 30, alignment: .trailing)
        }
        
        HStack {
            Text("quizResultScoreCard.quizType.advantage.point")
                .font(.caption)
            Spacer()
            Image(systemName: "plus")
                .font(.caption)
            Text(quizResult.quizType.advantageCandy, format: .number)
                .font(.callout)
                .frame(width: 30, alignment: .trailing)
        }
        
        Line()
            .stroke(
                scheme == .dark ? .white : .black,
                style: .init(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: [1, 5],
                    dashPhase: 2
                )
            )
            .frame(height: 20)
            .opacity(0.2)
        
        HStack {
            Spacer()
            Image("EarthCandy")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
            Text(estimatedCandy, format: .number)
        }
    }
}


