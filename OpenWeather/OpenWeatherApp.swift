//
//  OpenWeatherApp.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import SwiftUI

@main
struct OpenWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let service = OpenWeatherService()
            let viewModel = WeatherViewModel(weatherService: service)
            WeatherView(viewModel: viewModel)
        }
    }
}
