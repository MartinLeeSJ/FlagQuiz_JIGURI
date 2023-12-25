//
//  CountryDetailView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/23/23.
//

import SwiftUI
import MapKit



struct CountryDetailView: View {
    @StateObject private var viewModel: CountryDetailViewModel
    
    init(viewModel: CountryDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            if viewModel.countryDetail != nil {
                content
            }
        }
        .overlay {
            if viewModel.countryDetail == nil {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.send(.load)
        }
        
    }
    
    private var content: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region)
                .frame(
                    minHeight: 200,
                    idealHeight: 250,
                    maxHeight: 250
                )
                .frame(maxWidth: .infinity)
            
            flagAndName
            
            informationGrid
        }
    }
    
    @ViewBuilder
    private var flagAndName: some View {
        HStack(alignment: .top, spacing: 16) {
            URLImageView(viewModel.countryDetail?.flagLinks.png) {
                Text(viewModel.countryDetail?.id.flagEmoji ?? "")
                    .font(.largeTitle)
            }
            .frame(maxWidth: 160)
            .frame(height: 90)
            .padding(8)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .accessibilityLabel(viewModel.countryDetail?.flagLinks.alt ?? "Flag")
       
            
            
            VStack(alignment: .leading) {
                Text(viewModel.countryDetail?.name.official ?? "")
                    .font(.headline)
                    .lineLimit(3, reservesSpace: true)
                FlowingText(viewModel.countryDetail?.name.common ?? "")
                    .font(.subheadline)
                
            }
            .padding(.top, 8)
            
            Spacer()
            
        }
        .padding(.horizontal)
        
        Divider()
    }
    
    private var informationGrid: some View {
        LazyVGrid(
            columns: [GridItem(
                .adaptive(minimum: 120, maximum: .infinity),
                alignment: .top
            )],
            spacing: 16
        ) {
            
            ForEach(CountryDetailInfo.allCases, id: \.self) { info in
                VStack(alignment: .leading, spacing: 8) {
                    Text(info.localizedTitleKey)
                        .font(.caption)
                    
                    HStack {
                        Text(info.informativeText(from: viewModel.countryDetail))
                        Spacer()
                    }
                    .padding(8)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                
                
            }
        }
        .padding()
    }
}

#Preview {
    CountryDetailView(viewModel: .init(container: .init(services: StubService()),
                                       countryCode: FQCountryISOCode.chooseRandomly(1, except: nil).first!))
}
