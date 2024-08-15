//
//  Settinfs.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import Combine
import SwiftUI

struct GlobalSettings {
    let startGradientColor: CurrentValueSubject<Color, Never> = .init(UserStorage.shared.startGradientColor ?? .startGradient)
    let endGradientColor: CurrentValueSubject<Color, Never> = .init(UserStorage.shared.endGradientColor ?? .endGradient)
    let soundOnPressButton: CurrentValueSubject<Bool, Never> = .init(UserStorage.shared.soundOnPressButton)
    let temperatureUnit: CurrentValueSubject<TemperatureUnit, Never> = .init(UserStorage.shared.temperatureUnit)
}
