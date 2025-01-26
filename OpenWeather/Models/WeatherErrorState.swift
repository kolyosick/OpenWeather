//
//  WeatherErrorState.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

enum WeatherErrorState: Equatable {
    case none
    case emptyCity
    case serviceError(String)
}
