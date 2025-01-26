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
    @Published var errorState: WeatherErrorState = .none

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func searchWeather() {
        errorState = .none

        guard !city.isEmpty else {
            errorState = .emptyCity
            return
        }

        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.weather = response
                case .failure(let error):
                    self?.weather = nil
                    self?.errorState = .serviceError(error.localizedDescription)
                }
            }
        }
    }
}
