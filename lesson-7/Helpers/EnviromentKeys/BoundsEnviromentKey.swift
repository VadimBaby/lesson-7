//
//  HeightEnviromentKey.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import SwiftUI

struct BoundsEnviromentKey: EnvironmentKey {
    static var defaultValue: CGRect = UIApplication.shared.keyWindow?.bounds ?? .zero
}
