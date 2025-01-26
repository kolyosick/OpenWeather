//
//  WeatherCacheProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

protocol WeatherCacheProtocol {
    func save(weather: WeatherResponse)
    func load() -> WeatherResponse?
}
