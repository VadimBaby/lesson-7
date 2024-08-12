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

final class ContentViewModel: Combiner, ObservableObject {
    let input: Input
    @Published var output: Output
    
    private let authService: AuthAPIServiceContainable = AuthAPIService()
    private let apiService: CurrentWeaherContainable = WeatherAPIService()
    private let locationManager: LocationServiceProtocol = LocationService()
    
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Helpers
    private let onAuthComplete = PassthroughSubject<Void, Never>()
    
    init() {
        self.input = Input()
        self.output = Output()
        
        bind()
    }
}

private extension ContentViewModel {
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
                self?.locationManager.requestLocation()
            }
            .store(in: &cancellables)
        
        bindAuth()
        bindWeather()
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
        let weatherRequest = locationManager.currentLocation
            .dropFirst()
            .zip(onAuthComplete)
            .print()
            .map { $0.0 }
            .compactMap{ $0 }
            .map { [unowned self] location in
                print("location: \(location)")
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
}

extension ContentViewModel {
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let onReload = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var contentState: LoadableViewState = .loading
        var model: CurrentWeather = .empty
    }
}
