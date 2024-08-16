//
//  TemperatureUnit.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation

enum TemperatureUnit: String, CaseIterable {
    case degrees, fahrenheits
    
    var unit: String {
        self == .degrees ? "C" : "F"
    }
    
    var title: String {
        self.rawValue.capitalized
    }
}
