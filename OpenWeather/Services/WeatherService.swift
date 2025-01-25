//
//  WeatherService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

protocol WeatherService {
    func fetchWeather(for city: String, apiKey: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}
