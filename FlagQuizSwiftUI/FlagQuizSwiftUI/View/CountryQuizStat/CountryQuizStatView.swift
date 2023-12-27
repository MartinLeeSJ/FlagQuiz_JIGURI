//
//  CountryQuizStatView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct CountryQuizStatView: View {
    @Environment(\.isSearching) var isSearching
    @StateObject private var viewModel: CountryQuizStatViewModel
    @State private var query: String = ""
    
    var searchSuggestionsStats: [FQCountryQuizStat] {
        viewModel.stats.filter {
            guard let name = $0.id.localizedName else {
                return false
            }
            
            return name.localizedCaseInsensitiveContains(query)
        }
    }
    
    init(viewModel: CountryQuizStatViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func color(of stat: Int) -> Color {
        if stat == 0 { return .black }
        if stat > 0 { return .green }
        return .red
    }
    
    var body: some View {
        
        List($viewModel.stats) { stat in
            HStack(spacing: 16) {
                Text(stat.id.flagEmoji ?? "?")
                    .font(.title2)
                Text(stat.id.localizedName ?? "?")
                    .font(.caption)
                Spacer()
                Text("\(stat.quizStat.wrappedValue ?? 0)")
                    .foregroundStyle(
                        color(of: stat.quizStat.wrappedValue ?? 0)
                    )
            }
        }
        .searchable(text: $query)
        .searchSuggestions{
            List {
                ForEach(searchSuggestionsStats, id: \.self) { stat in
                    HStack(spacing: 16) {
                        Text(stat.id.flagEmoji ?? "?")
                            .font(.title2)
                        Text(stat.id.localizedName ?? "?")
                            .font(.caption)
                        Spacer()
                        Text("\(stat.quizStat ?? 0)")
                            .foregroundStyle(
                                color(of: stat.quizStat ?? 0)
                            )
                    }
                }
            }
            .listStyle(.plain)
            
        }
        .listStyle(.plain)
        .task {
            await viewModel.load()
        }
    }
    
    
}

#Preview {
    NavigationStack {
        CountryQuizStatView(
            viewModel: .init(
                container: .init(
                    services: StubService()
                )
            )
        )
    }
}
