//
//  WeatherURLFactoryProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

protocol WeatherURLFactoryProtocol {
    func makeWeatherURL(for city: String) -> URL?
}
