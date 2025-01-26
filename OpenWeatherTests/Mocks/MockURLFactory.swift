//
//  MockURLFactory.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

final class MockURLFactory: WeatherURLFactoryProtocol {
    func makeWeatherURL(for city: String) -> URL? {
        return URL(string: "https://mockurl.com/weather")
    }
}
