//
//  OnboardingStep.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 26.08.2024.
//

import Foundation

enum OnboardingStep: String, Identifiable, CaseIterable {
    case welcome
    case forWhat
    case letsGo
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .welcome:
            "Добро пожаловать!"
        case .forWhat:
            "Для чего это приложение?"
        case .letsGo:
            "Начните пользоваться уже сейчас!"
        }
    }
    
    var buttonTitle: String {
        self == .letsGo ? "GET STARTED" : "NEXT"
    }
    
    var nameImage: String {
        rawValue
    }
    
    var subtitle: String {
        switch self {
        case .welcome:
            return "Очень рады видеть вас"
        case .forWhat:
            return "Очевидно, чтоб погоду смотреть..."
        case .letsGo:
            return "Давайте, уже пора!"
        }
    }
}
