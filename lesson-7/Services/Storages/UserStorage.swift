//
//  UserStorage.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import SwiftUI

enum UserStorageKey: String {
    case startGradientColor, endGradientColor, soundOnPressButton, temperatureUnit
}

final class UserStorage {
    static var shared = UserStorage()
    
    private let storage: UserDefaults = .standard
    
    var startGradientColor: Color {
        get {
            guard let uiColor = storage.color(forKey: UserStorageKey.startGradientColor.rawValue) else { return .startGradient }
            
            return Color(uiColor: uiColor)
        }
        set {
            storage.setColor(UIColor(newValue), forKey: UserStorageKey.startGradientColor.rawValue)
        }
    }
    
    var endGradientColor: Color {
        get {
            guard let uiColor = storage.color(forKey: UserStorageKey.endGradientColor.rawValue) else { return .endGradient }
            
            return Color(uiColor: uiColor)
        }
        set {
            storage.setColor(UIColor(newValue), forKey: UserStorageKey.endGradientColor.rawValue)
        }
    }
    
    var soundOnPressButton: Bool {
        get {
            storage.bool(forKey: UserStorageKey.soundOnPressButton.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: UserStorageKey.soundOnPressButton.rawValue)
        }
    }
    
    var temperatureUnit: TemperatureUnit {
        get {
            guard let value = storage.string(forKey: UserStorageKey.temperatureUnit.rawValue) else { return .degrees }
            
            return TemperatureUnit(rawValue: value) ?? .degrees
        }
        set {
            storage.setValue(newValue.rawValue, forKey: UserStorageKey.temperatureUnit.rawValue)
        }
    }
    
    private init() {}
}
