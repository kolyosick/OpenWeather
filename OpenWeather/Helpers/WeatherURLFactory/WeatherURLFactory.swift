//
//  WeatherURLFactory.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

struct WeatherURLFactory: WeatherURLFactoryProtocol {
    private let baseURL: String
    private let apiKey: String

    init(baseURL: String = Constants.openWeatherURL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    func makeWeatherURL(for city: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return components?.url
    }
}
