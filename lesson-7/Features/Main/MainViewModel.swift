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
    
    private let authService: AuthAPIServiceContainable
    private let apiService: CurrentWeaherContainable
    private let locationService: LocationServiceProtocol
    private weak var router: MainViewRouter? = nil
    
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - External
    private let citySelected: CurrentValueSubject<Location?, Never>
    
    // MARK: - Helpers
    private let onAuthComplete = PassthroughSubject<Void, Never>()
    
    // MARK: - GlobalSettings
    
    private let globalSettings: GlobalSettings
    
    init(
        citySelected: CurrentValueSubject<Location?, Never>,
        authService: AuthAPIServiceContainable,
        apiService: CurrentWeaherContainable,
        locationService: LocationServiceProtocol,
        globalSettings: GlobalSettings,
        router: MainViewRouter?
    ) {
        self.citySelected = citySelected
        self.router = router
        self.authService = authService
        self.apiService = apiService
        self.locationService = locationService
        self.globalSettings = globalSettings
        
        self.input = Input()
        self.output = Output(globalSettings: globalSettings)
        
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
        
        onAuthComplete
            .sink { [weak self] in
                self?.locationService.requestLocation()
            }
            .store(in: &cancellables)
        
        bindAuth()
        bindWeather()
        bindNavigation()
        bindSettings()
    }
    
    // MARK: - Auth
    
    func bindAuth() {
        input.onAppear
            .first()
            .merge(with: input.onReload)
            .filter {
                KeychainManager.shared.token.isNotNilOrEmpty
            }
            .sink { [weak self] in
                self?.onAuthComplete.send()
            }
            .store(in: &cancellables)
        
        let request = input.onAppear
            .first()
            .merge(with: input.onReload)
            .filter {
                !KeychainManager.shared.token.isNotNilOrEmpty
            }
            .map { [unowned self] in
                self.authService.postToken().materialize()
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
        
        request
            .values()
            .print()
            .sink { [weak self] in
                KeychainManager.shared.token = $0.accessToken
                self?.onAuthComplete.send()
            }
            .store(in: &cancellables)
        
        request
            .failures()
            .sink { [weak self] error in
                self?.output.contentState = .error(message: error.localizedDescription)
            }
            .store(in: &cancellables)
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
            .combineLatest(onAuthComplete)
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
                self?.router?.routeToSettings()
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
        
        globalSettings.temperatureUnit
            .removeDuplicates()
            .mapToVoid()
            .sink { [weak self] in
                self?.onAuthComplete.send()
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
    }
    
    struct Output {
        var contentState: LoadableViewState = .loading
        var model: CurrentWeather = .empty
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
