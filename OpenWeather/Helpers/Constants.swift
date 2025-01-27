//
//  Constants.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

struct Constants {
    static let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "f5cb0b965ea1564c50c6f1b74534d823"
    static let cacheKey = "lastWeatherData"
    static let networkMonitorKey = "networkMonitor"
}

//TODO: Localisation
struct Message {
    static let noWeatherData = "No Weather Data"
    static let fetchingWeather = "Fetching weather…"
    static let enterCityName = "Please enter a city name."
    static let weather = "Weather"
    static let searchCity = "Search for a city"
    static let offlineNotice = "Offline Mode - Showing Cached Data"
}
