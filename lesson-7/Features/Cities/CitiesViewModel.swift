//
//  CitiesViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation
import SwiftUI
import Combine

final class CitiesViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let locationService: LocationServiceProtocol
    private weak var router: CitiesRouteView? = nil
    
    // MARK: - External
    
    private let citySelected: CurrentValueSubject<Location?, Never>
    
    // MARK: - GlobalSettings
    
    private let globalSettings: GlobalSettings
    
    init(
        citySelected: CurrentValueSubject<Location?, Never>,
        locationService: LocationServiceProtocol,
        globalSettings: GlobalSettings,
        router: CitiesRouteView?
    ) {
        self.citySelected = citySelected
        self.locationService = locationService
        self.globalSettings = globalSettings
        self.router = router
        
        self.input = Input()
        self.output = Output(globalSettings: globalSettings)
        
        self.appendCurrentLocation()
        self.bind()
    }
}

private extension CitiesViewModel {
    func bind() {
        input.onPress
            .sink { [weak self] city in
                self?.citySelected.send(city)
                self?.router?.goBack()
            }
            .store(in: &cancellables)
        
        citySelected
            .removeDuplicates()
            .sink { [weak self] city in
                self?.output.currentCity = city
            }
            .store(in: &cancellables)
        
        bindSearch()
        bindSettings()
    }
    
    // MARK: - Search
    
    func bindSearch() {
        let search = $output
            .map(\.search)
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .share()
        
        search
            .filter{ $0.count > 2 }
            .sink { [weak self] search in
                guard let self = self else { return }
                
                self.output.filteredCities = self.output.cities.filter{ $0.name.contains(search) }
            }
            .store(in: &cancellables)
        
        search
            .filter{ $0.count <= 2 }
            .sink { [weak self] search in
                guard let self = self else { return }
                
                self.output.filteredCities = self.output.cities
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Settings
    
    func bindSettings() {
        globalSettings.startGradientColor
            .sink { [weak self] color in
                self?.output.settings.startGradientColor = color
            }
            .store(in: &cancellables)
        
        globalSettings.endGradientColor
            .sink { [weak self] color in
                self?.output.settings.endGradientColor = color
            }
            .store(in: &cancellables)
        
        globalSettings.soundOnPressButton
            .sink { [weak self] value in
                self?.output.settings.soundOnPressButton = value
            }
            .store(in: &cancellables)
    }
    
    func appendCurrentLocation() {
        guard let coordinate = locationService.currentLocation.value else {
            return
        }
        
        output.cities.insert(Location(name: "Ваше местоположение", type: .myLocation, coordinate: coordinate), at: 0)
    }
}

extension CitiesViewModel {
    struct Input {
        let onPress = PassthroughSubject<Location, Never>()
    }
    
    struct Output {
        var filteredCities: [Location] = []
        var cities: [Location] = Location.mockCities
        var search: String = ""
        var currentCity: Location? = nil
        var settings: Settings
        
        init(globalSettings: GlobalSettings) {
            self.settings = .init(
                startGradientColor: globalSettings.startGradientColor.value,
                endGradientColor: globalSettings.endGradientColor.value,
                soundOnPressButton: globalSettings.soundOnPressButton.value
            )
        }
    }
    
    struct Settings {
        var startGradientColor: Color
        var endGradientColor: Color
        var soundOnPressButton: Bool
    }
}
