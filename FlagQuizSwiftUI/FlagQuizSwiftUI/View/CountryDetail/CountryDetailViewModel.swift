//
//  CountryDetailViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/23/23.
//

import SwiftUI
import Combine

import MapKit



@MainActor
final class CountryDetailViewModel: ObservableObject {
    @Published var countryDetail: FQCountryDetail? = nil
    @Published var region: MKCoordinateRegion = .init(.world)
    
    
    enum Action {
        case load
        case openInMaps
    }
    
    private let container: DIContainer
    private let countryCode: FQCountryISOCode
    private var cancellables = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        countryCode: FQCountryISOCode 
    ) {
        self.container = container
        self.countryCode = countryCode
    }
    
    public func send(_ action: Action) {
        switch action {
        case .load: load()
        case .openInMaps: openInMaps()
            
        }
    }
    
    
    private func load() {
        container.services.countryService.getCountryDetails(ofCodes: [countryCode])
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .compactMap { $0.first }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    //TODO: Error Handling
                    print(error.localizedDescription)
                    self?.countryDetail = FQCountryDetail.mock
                }
            } receiveValue: { [weak self] detail in
                self?.countryDetail = detail
                if let coordinateRegion = detail?.coordinateRegion {
                    self?.region = coordinateRegion
                }
            }
            .store(in: &cancellables)
    }
    
    private func openInMaps() {
        guard let localizedName = countryDetail?.id.localizedName else { return }
        let mapsURL: URL? = URL(
            string: "maps://?ll=\(region.center.latitude),\(region.center.longitude)&spn=\(region.span)"
        )
        
        if let mapsURL,
           UIApplication.shared.canOpenURL(mapsURL) {
            UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
        }
    }
    
    
}


