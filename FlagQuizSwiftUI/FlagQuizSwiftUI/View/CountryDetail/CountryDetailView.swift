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
        NavigationStack {
            ScrollView {
                VStack {
                    Map(coordinateRegion: $viewModel.region)
                        .frame(minHeight: 200, idealHeight: 250, maxHeight: 250)
                        .frame(maxWidth: .infinity)
                        
                    HStack(alignment: .top) {
                        AsyncImage(url: viewModel.countryDetail?.flagLinks.svgURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Text(viewModel.countryDetail?.id.flagEmoji ?? "")
                                .font(.largeTitle)
                        }
                        .frame(maxWidth: 160)
                        .frame(height: 90)
                        .padding(8)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 16)
                        
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
                    
                    
                    Text(viewModel.countryDetail?.capitals?.first ?? "None")
                }
            }
            .onAppear {
                //                viewModel.send(.load)
            }
        }
    }
}

#Preview {
    CountryDetailView(viewModel: .init(container: .init(services: StubService()),
                                       countryCode: FQCountryISOCode.chooseRandomly(1, except: nil).first!))
}
