//
//  CountryQuizStatView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct CountryQuizStatView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
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
        List {
            ForEach($viewModel.stats, id: \.self) { stat in
                listRow(data: stat.wrappedValue)
            }
        }
        .searchable(text: $query)
        .searchSuggestions{
            ForEach(searchSuggestionsStats, id: \.self) { stat in
                listRow(data: stat)
            }
        }
        .listStyle(.plain)
        .task {
            await viewModel.load()
        }
    }
    
    private func listRow(data stat: FQCountryQuizStat) -> some View {
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
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(Color(uiColor: .tertiaryLabel))
        }
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.countryDetail(stat.id))
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
        .environmentObject(NavigationModel())
    }
}
