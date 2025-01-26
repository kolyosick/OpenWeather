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
            let networkService = URLSessionNetworkService()
            let urlFactory = WeatherURLFactory(apiKey: Constants.apiKey)
            let cache = WeatherCache()
            let networkMonitor = NetworkMonitor()
            let service = OpenWeatherService(networkService: networkService,
                                             urlFactory: urlFactory,
                                             cache: cache,
                                             networkMonitor: networkMonitor)
            let viewModel = WeatherViewModel(weatherService: service,
                                             networkMonitor: networkMonitor,
                                             cache: cache)
            WeatherView(viewModel: viewModel)
        }
    }
}
