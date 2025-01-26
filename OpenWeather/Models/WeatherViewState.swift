//
//  WeatherViewState.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

enum WeatherViewState: Equatable {
    case normal
    case emptyCity
    case loading
    case serviceError(String)
}
