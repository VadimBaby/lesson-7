//
//  CitiesView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import SwiftUI

struct CitiesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: CitiesViewModel
    
    init(viewModel: CitiesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            searchTextField(search: $viewModel.output.search)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.output.filteredCities) { city in
                        Button(send: viewModel.input.onPress, model: city) {
                            cityCell(city)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .gradientBackground(
            start: viewModel.output.settings.startGradientColor,
            end: viewModel.output.settings.endGradientColor
        )
        .ignoresSafeArea()
    }
}

private extension CitiesView {
    @ViewBuilder func searchTextField(search: Binding<String>) -> some View {
        TextField("Search", text: search)
            .padding()
            .padding(.leading, 10)
            .overlay(alignment: .leading) {
                Image(systemName: "magnifyingglass")
            }
            .padding(.leading, 10)
            .background(Material.ultraThin)
            .clipShape(.rect(cornerRadius: 15))
            .padding([.horizontal, .top])
    }
    
    @ViewBuilder func cityCell(_ city: Location) -> some View {
        HStack {
            Text(city.name)
            
            Spacer()
            
            if city == viewModel.output.currentCity || (viewModel.output.currentCity == nil && city.type == .myLocation) {
                Image(systemName: "checkmark")
            } else {
                Image(systemName: "chevron.right")
            }
        }
        .font(.title3)
        .foregroundColor(Color.primary)
        .padding()
        .background(Material.ultraThin)
        .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    CitiesView(viewModel: .init(
        citySelected: .init(nil),
        locationService: LocationService(),
        globalSettings: .init(),
        router: nil)
    )
}
