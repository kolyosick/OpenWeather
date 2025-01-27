//
//  WeatherCacheProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

/// A protocol for saving and retrieving the last fetched weather data.
protocol WeatherCacheProtocol {
    /// Saves the provided `WeatherResponse` to the cache.
    ///
    /// - Parameter weather: The weather data to cache.
    func save(weather: WeatherResponse)

    /// Loads the last cached `WeatherResponse`, if available.
    ///
    /// - Returns: A `WeatherResponse` if found, otherwise `nil`.
    func load() -> WeatherResponse?
}
