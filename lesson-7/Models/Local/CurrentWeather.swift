//
//  CurrentWeather.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation

struct CurrentWeather {
    let time: String
    let temperature: Int
    let feelsLikeTemp: Double
    let windSpeed: Double
    let symbolPhrase: String
    let symbol: String
    let relHumidity: Double
    let windDirString: String
    let pressure: Double
    let visibility: Int
    
    static var empty: Self {
        .init(
            time: "",
            temperature: 0,
            feelsLikeTemp: 0,
            windSpeed: 0,
            symbolPhrase: "",
            symbol: "",
            relHumidity: 0,
            windDirString: "",
            pressure: 0,
            visibility: 0
        )
    }
}

extension CurrentWeather {
    init(serverEntity: ServerCurrentWeather) {
        self.init(
            time: serverEntity.time.orEmpty,
            temperature: Int(serverEntity.temperature.orZero),
            feelsLikeTemp: serverEntity.feelsLikeTemp.orZero,
            windSpeed: serverEntity.windSpeed.orZero,
            symbolPhrase: serverEntity.symbolPhrase.orEmpty,
            symbol: serverEntity.symbol.orEmpty,
            relHumidity: serverEntity.relHumidity.orZero,
            windDirString: serverEntity.windDirString.orEmpty,
            pressure: serverEntity.pressure.orZero,
            visibility: serverEntity.visibility.orZero
        )
    }
}
