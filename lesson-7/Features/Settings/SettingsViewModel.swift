//
//  SettingsViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let globalSettings: GlobalSettings
    
    init(globalSettings: GlobalSettings) {
        self.globalSettings = globalSettings
        
        self.input = Input()
        self.output = Output(
            startGradientColor: globalSettings.startGradientColor.value,
            endGradientColor: globalSettings.endGradientColor.value,
            soundOnPressButtonToggle: globalSettings.soundOnPressButton.value,
            temperatureUnit: globalSettings.temperatureUnit.value
        )
        
        self.bind()
    }
}

private extension SettingsViewModel {
    func bind() {
        $output
            .map(\.startGradientColor)
            .sink { [weak self] color in
                self?.globalSettings.startGradientColor.send(color)
            }
            .store(in: &cancellables)
        
        $output
            .map(\.endGradientColor)
            .sink { [weak self] color in
                self?.globalSettings.endGradientColor.send(color)
            }
            .store(in: &cancellables)
        
        $output
            .map(\.soundOnPressButtonToggle)
            .sink { [weak self] toggleValue in
                self?.globalSettings.soundOnPressButton.send(toggleValue)
            }
            .store(in: &cancellables)
        
        $output
            .map(\.temperatureUnit)
            .sink { [weak self] temperatureUnit in
                self?.globalSettings.temperatureUnit.send(temperatureUnit)
            }
            .store(in: &cancellables)
    }
}

extension SettingsViewModel {
    struct Input {
        
    }
    
    struct Output {
        var startGradientColor: Color
        var endGradientColor: Color
        var soundOnPressButtonToggle: Bool
        var temperatureUnit: TemperatureUnit
    }
}
