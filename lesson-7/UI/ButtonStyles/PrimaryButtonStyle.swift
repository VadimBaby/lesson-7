//
//  PrimaryButtonStyle.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    let color: Color
    let disabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(20)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(disabled ? Color.gray : color)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
