//
//  SettingsView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsService
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let xmarkSize: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 40) {
            headerSection
            
            VStack(spacing: 15) {
                TextField("place", text: $settings.text)
                ColorPicker("Pick First Color", selection: $settings.startGradientColor)
                ColorPicker("Pick Second Color", selection: $settings.endGradientColor)
                
                Toggle("Sound", isOn: $settings.soundOnPressButton)
                
                VStack(alignment: .leading) {
                    Text("Temperature Unit:")
                    
                    Picker("Temperature Unit", selection: $settings.temperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.rawValue) { temperatureUnit in
                            Text(temperatureUnit.title)
                                .tag(temperatureUnit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            Spacer()
        }
        .padding()
        .font(20, weight: .medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gradientBackground(
            start: settings.startGradientColor,
            end: settings.endGradientColor
        )
    }
}

private extension SettingsView {
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: xmarkSize, height: xmarkSize)
            
            Text("Настройки")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(
                send: viewModel.input.goBack,
                with: .what,
                isSoundOn: settings.soundOnPressButton
            ) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: xmarkSize)
            }
        }
        .foregroundColor(Color.black)
    }
}

#Preview {
    SettingsView(viewModel: .init(router: nil))
        .environmentObject(SettingsService())
}
