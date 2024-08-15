//
//  SettingsView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let xmarkSize: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 40) {
            headerSection
            
            VStack(spacing: 15) {
                ColorPicker("Pick First Color", selection: $viewModel.output.startGradientColor)
                ColorPicker("Pick Second Color", selection: $viewModel.output.endGradientColor)
                
                Toggle("Sound", isOn: $viewModel.output.soundOnPressButtonToggle)
                
                VStack(alignment: .leading) {
                    Text("Temperature Unit:")
                    
                    Picker("Temperature Unit", selection: $viewModel.output.temperatureUnit) {
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
            start: viewModel.output.startGradientColor,
            end: viewModel.output.endGradientColor
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
                dismiss: dismiss,
                with: .what,
                isSoundOn: viewModel.output.soundOnPressButtonToggle
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
    SettingsView(viewModel: .init(globalSettings: GlobalSettings()))
}
