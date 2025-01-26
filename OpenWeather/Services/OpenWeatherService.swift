//
//  OpenWeatherService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

final class OpenWeatherService: WeatherServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let urlFactory: WeatherURLFactoryProtocol
    var cache: WeatherCacheProtocol
    private let networkMonitor: NetworkMonitorProtocol

    init(networkService: NetworkServiceProtocol,
         urlFactory: WeatherURLFactoryProtocol,
         cache: WeatherCacheProtocol,
         networkMonitor: NetworkMonitorProtocol) {
        self.networkService = networkService
        self.urlFactory = urlFactory
        self.cache = cache
        self.networkMonitor = networkMonitor
    }

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if !networkMonitor.isConnected {
            if let cachedWeather = cache.load() {
                completion(.success(cachedWeather))
            } else {
                completion(.failure(URLError(.notConnectedToInternet)))
            }
            return
        }

        guard let url = urlFactory.makeWeatherURL(for: city) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        networkService.fetch(WeatherResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.cache.save(weather: weather)
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

