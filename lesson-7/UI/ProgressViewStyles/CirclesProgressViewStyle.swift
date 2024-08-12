//
//  CirclesProgressViewStyle.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import SwiftUI

struct CirclesProgressViewStyle: ProgressViewStyle {
    
    @State private var isAnimating = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 14) {
            ForEach(0..<3) { index in
                Rectangle()
                    .fill(Color.cyan)
                    .frame(width: 15, height: 15)
                    .clipShape(.rect(cornerRadius: isAnimating ? 7 : 0))
                    .scaleEffect(isAnimating ? 1.4 : 1, anchor: .center)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    ProgressView()
        .progressViewStyle(CirclesProgressViewStyle())
}
