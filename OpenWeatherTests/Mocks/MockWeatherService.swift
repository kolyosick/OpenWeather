//
//  MockWeatherService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

final class MockWeatherService: WeatherServiceProtocol {
    var fetchWeatherCalled = false
    var mockResult: Result<WeatherResponse, Error>?
    var mockCache: MockWeatherCache = MockWeatherCache()

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        fetchWeatherCalled = true
        if let result = mockResult {
            completion(result)
        }
    }
}

extension MockWeatherService {
    var cache: WeatherCacheProtocol {
        mockCache
    }
}

