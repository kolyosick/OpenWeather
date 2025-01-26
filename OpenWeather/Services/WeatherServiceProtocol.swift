//
//  WeatherServiceProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}
