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
    @State private var didTapOpenInMaps: Bool = false
    
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
            maps
            
            flagAndName
            
            informationGrid
        }
    }
    
    private var maps: some View {
        Map(coordinateRegion: $viewModel.region)
            .frame(
                minHeight: 200,
                idealHeight: 250,
                maxHeight: 250
            )
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    didTapOpenInMaps = true
                } label: {
                    Text("open.in.maps")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .offset(x: -10, y: -10)
            }
            .alert("leave.apps", isPresented: $didTapOpenInMaps) {
                Button("open") {
                    viewModel.send(.openInMaps)
                    didTapOpenInMaps = false
                }
            } message: {
                Text("will.open.in.maps.question")
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
                FlowingText(viewModel.countryDetail?.name.official ?? "-")
                    .font(.headline)
                
                FlowingText(viewModel.countryDetail?.id.localizedName ?? "-" )
                    .font(.subheadline)
                
                FlowingText(viewModel.countryDetail?.name.common ?? "-")
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
