//
//  WeatherURLFactoryProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

/// A protocol defining a factory for constructing weather-related URLs.
protocol WeatherURLFactoryProtocol {
    /// Creates a `URL` for fetching weather data for a specified city.
    ///
    /// - Parameter city: A `String` representing the city’s name.
    /// - Returns: A `URL` if the city can be transformed into a valid endpoint; otherwise `nil`.
    func makeWeatherURL(for city: String) -> URL?
}
