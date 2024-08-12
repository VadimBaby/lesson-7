//
//  EnviromentValues.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  var bounds: CGRect {
    get { self[BoundsEnviromentKey.self] }
  }
}
