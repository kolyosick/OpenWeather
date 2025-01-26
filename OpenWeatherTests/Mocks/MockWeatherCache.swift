//
//  MockWeatherCache.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

final class MockWeatherCache: WeatherCacheProtocol {
    var cachedWeather: WeatherResponse?

    func save(weather: WeatherResponse) {
        cachedWeather = weather
    }

    func load() -> WeatherResponse? {
        return cachedWeather
    }
}
