//
//  MainCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation
import Stinsen
import SwiftUI
import Combine

final class MainCoordinator: NavigationCoordinatable {
    var stack = Stinsen.NavigationStack<MainCoordinator>(initial: \.start)
    
    @Root var start = makeMainView
    
    @Route(.modal) var cities = makeCitiesView
    @Route(.fullScreen) var settings = makeSettingsView
    
    @Injected private var authService: AuthAPIService
    @Injected private var apiService: WeatherAPIService
    @Injected private var locationService: LocationService
    
    init() {
        self.bind()
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let citySelected = CurrentValueSubject<Location?, Never>(nil)
    
    // MARK: - Settings
    
    private let globalSettings = GlobalSettings()
}

private extension MainCoordinator {
    func bind() {
        globalSettings.startGradientColor
            .removeDuplicates()
            .sink { color in
                UserStorage.shared.startGradientColor = color
            }
            .store(in: &cancellables)
        
        globalSettings.endGradientColor
            .removeDuplicates()
            .sink { color in
                UserStorage.shared.endGradientColor = color
            }
            .store(in: &cancellables)
        
        globalSettings.soundOnPressButton
            .removeDuplicates()
            .sink { value in
                UserStorage.shared.soundOnPressButton = value
            }
            .store(in: &cancellables)
        
        globalSettings.temperatureUnit
            .removeDuplicates()
            .sink { value in
                UserStorage.shared.temperatureUnit = value
            }
            .store(in: &cancellables)
    }
}

private extension MainCoordinator {
    @ViewBuilder
    func makeMainView() -> some View {
        let viewModel = MainViewModel(
            citySelected: citySelected,
            authService: authService,
            apiService: apiService,
            locationService: locationService,
            globalSettings: globalSettings,
            router: self
        )
        MainView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeCitiesView() -> some View {
        let viewModel = CitiesViewModel(
            citySelected: citySelected,
            locationService: locationService,
            globalSettings: globalSettings,
            router: self
        )
        
        CitiesView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeSettingsView() -> some View {
        let viewModel = SettingsViewModel(globalSettings: globalSettings)
        SettingsView(viewModel: viewModel)
    }
}
