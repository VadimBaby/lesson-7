//
//  City.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation
import CoreLocation

enum TypeLocation {
    case city, myLocation
}

struct Location: Identifiable {
    let id: UUID = UUID()
    let name: String
    let type: TypeLocation
    let coordinate: CLLocationCoordinate2D
}

extension Location {
    static let mockCities: [Location] = [
        .init(name: "Омск", type: .city, coordinate: .init(latitude: 54.989347, longitude: 73.368221)),
        .init(name: "Новосибирск", type: .city, coordinate: .init(latitude: 55.030204, longitude: 82.920430)),
        .init(name: "Саратов", type: .city, coordinate: .init(latitude: 51.533562, longitude: 46.034266)),
        .init(name: "Москва", type: .city, coordinate: .init(latitude: 55.755864, longitude: 37.617698)),
        .init(name: "Майами", type: .city, coordinate: .init(latitude: 25.792235, longitude: -80.250852)),
        .init(name: "Дубай", type: .city, coordinate: .init(latitude: 25.229762, longitude: 55.289311)),
        .init(name: "Амстердам", type: .city, coordinate: .init(latitude: 52.373057, longitude: 4.892557)),
        .init(name: "Лос-Анджелес", type: .city, coordinate: .init(latitude: 34.055863, longitude: -118.246139)),
        .init(name: "Астана", type: .city, coordinate: .init(latitude: 51.128201, longitude: 71.430429)),
        .init(name: "Владивосток", type: .city, coordinate: .init(latitude: 43.115542, longitude: 131.885494))
    ]
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
