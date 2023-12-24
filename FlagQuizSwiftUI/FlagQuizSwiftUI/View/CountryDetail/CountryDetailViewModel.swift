//
//  CountryDetailViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/23/23.
//

import SwiftUI
import Combine

import MapKit




final class CountryDetailViewModel: ObservableObject {
    //임시로 Mock
    @Published var countryDetail: FQCountryDetail? = nil {
        didSet {
            if let coordinateRegion = countryDetail?.coordinateRegion {
                self.region = coordinateRegion
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
            }
            .store(in: &cancellables)

    }
    
    
}


typealias CountryDetailInfo = CountryDetailViewModel.CountryDetailInfo

extension CountryDetailViewModel {
    enum CountryDetailInfo: String, CaseIterable {
        case capitals
        case coordinates
        case languages
        case area
        case population
        case borderedCountries
        case timezones
        case continents
        
        
    // MARK: - 보라색 에러가 왜 발생하는지 연구해보기
        var localizedTitleKey: LocalizedStringKey {
            switch self {
            case .capitals:
                "county.detail.title.capitals"
            case .coordinates:
                "county.detail.title.coordinates"
            case .languages:
                "county.detail.title.languages"
            case .area:
                "county.detail.title.area"
            case .population:
                "county.detail.title.population"
            case .borderedCountries:
                "county.detail.title.borderedCountries"
            case .timezones:
                "county.detail.title.timezones"
            case .continents:
                "county.detail.title.continents"
            }
        }
        
        private var measurementFormatter: MeasurementFormatter {
            let formatter: MeasurementFormatter = MeasurementFormatter()
            formatter.unitOptions = .naturalScale
            formatter.unitStyle = .short
            return formatter
        }
        
        
        func informativeText(from detail: FQCountryDetail?) -> String {
            guard let detail else { return "" }
        
            switch self {
            case .capitals:
               return detail.capitals?.joined(separator: ", ") ?? "-"
            case .coordinates:
                return detail.coordinates.compactMap { $0.description }.joined(separator: ", ")
            case .languages:
                return detail.languages.joined(separator: ", ")
            case .area:
                return measurementFormatter.string(
                    from: .init(
                        value: Double(detail.area * 1_000_000),
                        unit: UnitArea(forLocale: .current)
                    )
                )
            case .population:
                return measurementFormatter.string(
                    from: .init(
                        value: Double(detail.population),
                        unit: .init(symbol: "")
                    )
                )

            case .borderedCountries:
                return detail
                    .borderedCountries?
                    .compactMap {
                        Locale.current.localizedString(forRegionCode: $0)
                    }
                    .joined(separator: ", ") ?? "-"
            case .timezones:
                return detail.timezones.joined(separator: ", ")
            case .continents:
                return detail.continents.map { $0.localizedName }.joined(separator: ", ")
            }
            
            
        }
    }
}