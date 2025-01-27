//
//  WeatherView.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !viewModel.isConnected {
                    OfflineNotice()
                }
                switch viewModel.viewState {
                case .normal:
                    if let weather = viewModel.weather {
                        WeatherDetailView(weather: weather)
                    } else {
                        ContentUnavailableView {
                            Label(Message.noWeatherData, systemImage: "questionmark.circle.fill")
                        }
                    }
                case .loading:
                    ProgressView(Message.fetchingWeather)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    
                case .emptyCity:
                    Text(Message.enterCityName)
                        .foregroundColor(.red)
                    
                case .serviceError(let message):
                    Text(message)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(Message.weather)
            .searchable(text: $viewModel.city, prompt: Message.searchCity)
            .onSubmit(of: .search) {
                viewModel.searchWeather()
            }
        }
        .navigationViewStyle(.stack)
    }
}
