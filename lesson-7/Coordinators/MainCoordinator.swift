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
    
    @Injected private var apiService: WeatherAPIService
    @Injected private var locationService: LocationService
    
    private var settingsService: SettingsService
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let citySelected = CurrentValueSubject<Location?, Never>(nil)
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }
    
    // MARK: - Navigations Functions
    
    func goBack() {
        self.popLast()
    }
}

private extension MainCoordinator {
    @ViewBuilder
    func makeMainView() -> some View {
        let viewModel = MainViewModel(
            citySelected: citySelected,
            apiService: apiService,
            locationService: locationService,
            settingsService: settingsService,
            router: self
        )
        MainView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeCitiesView() -> some View {
        let viewModel = CitiesViewModel(
            citySelected: citySelected,
            locationService: locationService,
            router: self
        )
        
        CitiesView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeSettingsView() -> some View {
        let viewModel = SettingsViewModel(router: self)
        SettingsView(viewModel: viewModel)
    }
}
