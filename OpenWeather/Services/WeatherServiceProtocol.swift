//
//  WeatherServiceProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

/// A protocol defining a weather service that can fetch weather data
/// and manage a local cache.
protocol WeatherServiceProtocol {
    /// The cache used to store and retrieve the last fetched weather data.
    var cache: WeatherCacheProtocol { get }

    /// Fetches weather data for the specified city.
    ///
    /// - Parameters:
    ///   - city: The city name for which to request weather data.
    ///   - completion: A closure called with a `Result` containing
    ///                 either a `WeatherResponse` or an `Error`.
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}
