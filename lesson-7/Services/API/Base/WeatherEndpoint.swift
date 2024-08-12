//
//  WeatherEndpoint.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Moya
import CoreLocation

enum ResponseLanguage: String {
    case ru, en
}

enum WeatherEndpoint: TargetType {
    case current(location: CLLocationCoordinate2D)
    case daily(location: CLLocationCoordinate2D)
    
    var baseURL: URL {
        guard let url = URL(string: "https://pfa.foreca.com/api/v1") else {
            fatalError("Incorrect \(self) baseURL!")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .current(let location):
            return "current/\(map(location: location))"
        case .daily(let location):
            return "forecast/daily/\(map(location: location))"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        .requestParameters(
            parameters: ["lang" : language.rawValue],
            encoding: URLEncoding.default
        )
    }
    
    var headers: [String : String]? {
        var headers = [String : String]()
        headers["Content-Type"] = "application/json"
        
        if let token = KeychainManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
}

private extension WeatherEndpoint {
    func map(location: CLLocationCoordinate2D) -> String {
        "\(location.longitude), \(location.latitude)"
    }
    
    var language: ResponseLanguage {
        ResponseLanguage(rawValue: Locale.current.languageCode.orEmpty) ?? .en
    }
}
