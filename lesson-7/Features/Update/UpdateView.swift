//
//  UpdateView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "arrow.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
            
            Text("Данные версия приложения устарела. Обновите приложение")
                .multilineTextAlignment(.center)
        }
        .font(22, weight: .medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gradientBackground(
            start: settings.startGradientColor,
            end: settings.endGradientColor
        )
    }
}

#Preview {
    UpdateView()
        .environmentObject(SettingsService())
}
