//
//  QuizRecordView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import SwiftUI

struct QuizRecordView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: QuizRecordViewModel
    
    init(viewModel: QuizRecordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                ForEach($viewModel.quizRecords) { record in
                    QuizRecordListRow(record: record.wrappedValue)
                }
            } header: {
                QuizRecordListHeader()
            }

            if viewModel.loadingState == .none {
                progressView
            }
        }
        .animation(.easeIn, value: viewModel.quizRecords.count)
        .listStyle(.plain)
        .overlay {
            if viewModel.loadingState == .failure {
                ErrorView {
                    viewModel.loadingState = .none
                }
            }
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .id(UUID())
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .onAppear {
                load()
            }
    }
    
    private func load() {
        Task {
            do {
                try await Task.sleep(for: .milliseconds(1000))
               
                await viewModel.load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

struct QuizRecordListRow: View {
    @EnvironmentObject private var container: DIContainer
    private let record: FQQuizRecord
    
    
    init(record: FQQuizRecord) {
        self.record = record
    }
    
    var body: some View {
        HStack {
            Group {
                Text(record.createdAt, style: .date)
                    .foregroundStyle(.secondary)
                Text(record.createdAt, style: .time)
                    .fontWeight(.medium)
            }
            .font(.caption)
            
            Spacer()
            
            Text(record.score.scoreFractionDescription)
                .font(.caption)
            
            record.score.classifiedScore.badge
                .imageScale(.large)
                .foregroundStyle(record.score.classifiedScore.tintColor)
            
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .imageScale(.small)

        }
        .onTapGesture {
            container.navigationModel.navigate(
                to: NewsDestination.quizRecordDetail(record)
            )
        }

    }
}

struct QuizRecordListHeader: View {
    var body: some View {
        HStack {
            Text("quiz.record.list.header.date.and.time")
            Spacer()
            Text("quiz.record.list.header.score")
                .padding(.trailing, 32)
        }
        .font(.caption)
    }
}


#Preview("Entire View") {
    
        QuizRecordView(
            viewModel: .init(
                container: .init(
                    services: StubService()
                )
            )
        )
        .environmentObject(DIContainer(services: StubService()))
        
    
}


