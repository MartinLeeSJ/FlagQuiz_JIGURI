//
//  CountryDetailViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/23/23.
//

import Foundation
import Combine

import MapKit

final class CountryDetailViewModel: ObservableObject {
    //임시로 Mock
    @Published var countryDetail: FQCountryDetail? = FQCountryDetail.mock {
        didSet {
            if let coordinates = countryDetail?.coordinates,
               let latitude = coordinates.first,
               let longitude = coordinates.last {
                let center: CLLocationCoordinate2D = .init(latitude: latitude, longitude: longitude)
                self.region = .init(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
            }
        }
    }
    @Published var region: MKCoordinateRegion = .init(.world)
    
    
    enum Action {
        case load
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
        case .load:
            Task {
                await load()
            }
        
        }
    }
    
    @MainActor
    private func load() {
        container.services.countryService.getCountryDetails(ofCodes: [countryCode])
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
            }
            .store(in: &cancellables)

    }
    
    
}
