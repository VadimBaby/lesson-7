//
//  Settings.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 16.08.2024.
//

import Foundation
import SwiftUI
import Combine

final class SettingsService: ObservableObject {
    @Published var startGradientColor: Color = UserStorage.shared.startGradientColor
    @Published var endGradientColor: Color = UserStorage.shared.endGradientColor
    @Published var soundOnPressButton: Bool = UserStorage.shared.soundOnPressButton
    @Published var temperatureUnit: TemperatureUnit = UserStorage.shared.temperatureUnit
    @Published var text: String = ""
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        bind()
    }
}

private extension SettingsService {
    func bind() {
        $startGradientColor
            .sink { color in
                UserStorage.shared.startGradientColor = color
            }
            .store(in: &cancellables)
        
        $endGradientColor
            .sink { color in
                UserStorage.shared.endGradientColor = color
            }
            .store(in: &cancellables)
        
        $soundOnPressButton
            .sink { value in
                UserStorage.shared.soundOnPressButton = value
            }
            .store(in: &cancellables)
        
        $temperatureUnit
            .sink { value in
                UserStorage.shared.temperatureUnit = value
            }
            .store(in: &cancellables)
    }
}


