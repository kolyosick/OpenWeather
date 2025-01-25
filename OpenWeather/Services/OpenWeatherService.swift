//
//  OpenWeatherService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

final class OpenWeatherService {
    private let networkService: NetworkServiceProtocol
    private let urlFactory: WeatherURLFactoryProtocol

    init(networkService: NetworkServiceProtocol,
         urlFactory: WeatherURLFactoryProtocol = WeatherURLFactory(apiKey: Constants.apiKey)) {
        self.networkService = networkService
        self.urlFactory = urlFactory
    }

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let url = urlFactory.makeWeatherURL(for: city) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        networkService.fetch(WeatherResponse.self, from: url, completion: completion)
    }
}

