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

    /// Maps a weather icon name to a unique SF Symbol.
    /// This covers all 9 currently available OpenWeather conditions (considering day/night).
    /// reference: https://openweathermap.org/weather-conditions
    ///
    static func mapIconToSFSymbol(_ icon: String) -> String {
        switch icon {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "smoke.fill"
        case "09d", "09n":
            return "cloud.drizzle.fill"
        case "10d":
            return "cloud.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d", "11n":
            return "cloud.bolt.rain.fill"
        case "13d", "13n":
            return "cloud.snow.fill"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "cloud"
        }
    }
}

