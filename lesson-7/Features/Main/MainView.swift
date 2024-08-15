//
//  ContentView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadableView(
            state: viewModel.output.contentState,
            content: content,
            onAppear: viewModel.input.onAppear.send,
            onReload: viewModel.input.onReload.send
        )
    }
}

private extension MainView {
    @ViewBuilder
    func content() -> some View {
        VStack(spacing: 30) {
            temperatureAndDayView
            weatherCardsView
            
            Spacer()
            
            Button(
                send: viewModel.input.onButtonPress,
                with: .what,
                isSoundOn: viewModel.output.settings.soundOnPressButton
            ) {
                Text("Выбрать город")
                    .foregroundStyle(Color.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Material.ultraThin)
                    .clipShape(.rect(cornerRadius: 15))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .gradientBackground(
            start: viewModel.output.settings.startGradientColor,
            end: viewModel.output.settings.endGradientColor
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    send: viewModel.input.onGearPress,
                    with: .what,
                    isSoundOn: viewModel.output.settings.soundOnPressButton
                ) {
                    Image(systemName: "gear")
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
    
    @ViewBuilder
    var temperatureAndDayView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(DateFormatters.shared.mediumDateFormatter.string(from: Date()))
                    .font(.system(size: 15, weight: .medium))
                Text("\(viewModel.output.model.temperature)°")
                    .font(.system(size: 50, weight: .bold))
                Text("Ощущается как: \(Int(viewModel.output.model.feelsLikeTemp))°")
                    .font(.system(size: 15, weight: .medium))
            }
            Spacer()
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(Color.white)
        }
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var weatherCardsView: some View {
        VStack(spacing: 10) {
            HStack {
                weatherCard(
                    "Влажность",
                    value: Int(viewModel.output.model.relHumidity),
                    prefix: "%"
                )
                weatherCard(
                    "Скорость ветра",
                    value: Int(viewModel.output.model.windSpeed),
                    prefix: "м/с, -> \(viewModel.output.model.windDirString)"
                )
            }
            
            HStack {
                weatherCard(
                    "Видимость",
                    value: Int(viewModel.output.model.visibility),
                    prefix: "м"
                )
                weatherCard(
                    "Давление",
                    value: Int(viewModel.output.model.pressure),
                    prefix: "мм. рт. ст."
                )
            }
        }
    }
    
    @ViewBuilder
    func weatherCard(_ title: String, value: Int, prefix: String = "") -> some View {
        VStack {
            Text(title)
            Text("\(value) \(prefix)")
        }
        .foregroundStyle(Color.primary)
        .padding()
        .background(Material.thin)
        .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    NavigationView {
        MainView(viewModel: .init(
            citySelected: .init(nil),
            authService: AuthAPIService(),
            apiService: WeatherAPIService(),
            locationService: LocationService(),
            globalSettings: GlobalSettings(),
            router: nil)
        )
    }
}
