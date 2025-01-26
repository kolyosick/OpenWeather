//
//  WeatherCache.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

final class WeatherCache: WeatherCacheProtocol {
    private let userDefaults: UserDefaults
    private let cacheKey: String

    init(userDefaults: UserDefaults = .standard, cacheKey: String = Constants.cacheKey) {
        self.userDefaults = userDefaults
        self.cacheKey = cacheKey
    }

    func save(weather: WeatherResponse) {
        if let data = try? JSONEncoder().encode(weather) {
            userDefaults.set(data, forKey: cacheKey)
        }
    }

    func load() -> WeatherResponse? {
        guard let data = userDefaults.data(forKey: cacheKey) else {
            return nil
        }
        return try? JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
