//
//  View.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import SwiftUI

extension View {
    func gradientBackground(start: Color = .startGradient, end: Color = .endGradient) -> some View {
        self
            .background {
                LinearGradient(
                    colors: [start, end],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
            }
    }
    
    func font(_ size: CGFloat, weight: Font.Weight = .regular, color: Color = Color.white) -> some View {
        self
            .foregroundStyle(color)
            .font(.system(size: size, weight: weight))
    }
}
