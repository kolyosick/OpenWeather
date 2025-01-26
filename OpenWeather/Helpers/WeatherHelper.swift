//
//  WeatherHelper.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

struct WeatherHelper {
    /// Converts a temperature from Kelvin to an integer Celsius value.
    static func kelvinToCelsius(_ kelvin: Double) -> Int {
        let celsius = kelvin - 273.15
        return Int(celsius)
    }

    /// Maps a weather condition string to a unique SF Symbol.
    /// This covers all 9 currently available OpenWeather conditions (ignoring day/night)
    static func mapConditionToSFSymbol(_ condition: String) -> String {
        let lowerCondition = condition.lowercased()
        
        switch lowerCondition {
        case let s where s.contains("clear sky"):
            return "sun.max.fill"
        case let s where s.contains("few clouds"):
            return "cloud.sun.fill"
        case let s where s.contains("scattered clouds"):
            return "cloud.fill"
        case let s where s.contains("broken clouds"):
            return "smoke.fill"
        case let s where s.contains("shower rain"):
            return "cloud.drizzle.fill"
        case let s where s.contains("rain"):
            return "cloud.rain.fill"
        case let s where s.contains("thunderstorm"):
            return "cloud.bolt.rain.fill"
        case let s where s.contains("snow"):
            return "cloud.snow.fill"
        case let s where s.contains("mist"):
            return "cloud.fog.fill"
        default:
            return "cloud"
        }
    }
}

