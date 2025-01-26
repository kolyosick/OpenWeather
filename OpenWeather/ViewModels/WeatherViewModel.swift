//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import SwiftUI

final class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: WeatherResponse?
    @Published var viewState: WeatherViewState = .normal

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func searchWeather() {
        viewState = .normal

        guard !city.isEmpty else {
            viewState = .emptyCity
            return
        }

        viewState = .loading

        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.weather = response
                    self?.viewState = .normal
                case .failure(let error):
                    self?.weather = nil
                    self?.viewState = .serviceError(error.localizedDescription)
                }
            }
        }
    }
}
