//
//  WeatherAPI.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Moya
import Combine
import CombineMoya
import CoreLocation

final class WeatherAPIService {
    private let provider = Provider<WeatherEndpoint>()
}

extension WeatherAPIService: CurrentWeaherContainable {
    func getCurrentWeather(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeather, MoyaError> {
        return provider.requestPublisher(.current(location: location))
            .filterSuccessfulStatusCodes()
            .map(ServerCurrentWeatherResponse.self)
            .map { CurrentWeather(serverEntity: $0.current) }
            .mapError({ error in
                print(error.errorUserInfo)
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


protocol CurrentWeaherContainable {
    func getCurrentWeather(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeather, MoyaError>
}
