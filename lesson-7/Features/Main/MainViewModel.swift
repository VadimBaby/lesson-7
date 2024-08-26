//
//  ContentViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Combine
import Moya
import CombineExt
import SwiftUI

final class MainViewModel: Combiner, ObservableObject {
    let input: Input
    @Published var output: Output
    
    private let apiService: CurrentWeaherContainable
    private let locationService: LocationServiceProtocol
    private var settingsService: SettingsService
    private weak var router: MainViewRouter? = nil
    
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - External
    private let citySelected: CurrentValueSubject<Location?, Never>
    
    init(
        citySelected: CurrentValueSubject<Location?, Never>,
        apiService: CurrentWeaherContainable,
        locationService: LocationServiceProtocol,
        settingsService: SettingsService,
        router: MainViewRouter?
    ) {
        self.citySelected = citySelected
        self.router = router
        self.apiService = apiService
        self.locationService = locationService
        self.settingsService = settingsService
        
        self.input = Input()
        self.output = Output()
        
        bind()
    }
}

private extension MainViewModel {
    func bind() {
        input.onAppear
            .first()
            .merge(with: input.onReload)
            .sink { [weak self] in
                self?.output.contentState = .loading
            }
            .store(in: &cancellables)
        
        input.onAppear
            .sink { [weak self] in
                self?.locationService.requestLocation()
            }
            .store(in: &cancellables)
        
        bindWeather()
        bindNavigation()
    }
    
    // MARK: - Weather
    
    func bindWeather() {
        let weatherRequest = locationService.currentLocation
            .combineLatest(citySelected)
            .map {
                guard $0.1 != nil else { return $0.0 }
                
                return $0.1?.coordinate
            }
            .compactMap{ $0 }
            .combineLatest(input.onAppear)
            .print()
            .map(\.0)
            .map { [unowned self] location in
                return self.apiService.getCurrentWeather(location: location)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        weatherRequest
            .values()
            .sink { [weak self] currentWeather in
                guard let self else { return }
                
                self.output.model = currentWeather
                self.output.contentState = .loaded
            }
            .store(in: &cancellables)
        
        weatherRequest
            .failures()
            .sink { [weak self] error in
                self?.output.contentState = .error(message: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        settingsService.$temperatureUnit
            .removeDuplicates()
            .zip(input.onSettingsDisappear)
            .sink(send: input.onAppear)
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    func bindNavigation() {
        input.onButtonPress
            .sink { [weak self] in
                self?.router?.routeToCities()
            }
            .store(in: &cancellables)
        
        input.onGearPress
            .sink { [weak self] in
                guard let safeSelf = self else { return }
                
                safeSelf.router?.routeToSettings { [weak self] in
                    self?.input.onSettingsDisappear.send()
                }
            }
            .store(in: &cancellables)
    }
}

extension MainViewModel {
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let onReload = PassthroughSubject<Void, Never>()
        let onButtonPress = PassthroughSubject<Void, Never>()
        let onGearPress = PassthroughSubject<Void, Never>()
        let onSettingsDisappear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var contentState: LoadableViewState = .loading
        var model: CurrentWeather = .empty
    }
}
