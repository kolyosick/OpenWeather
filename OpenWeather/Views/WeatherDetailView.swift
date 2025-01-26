//
//  WeatherDetailView.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherResponse

    var body: some View {
        VStack(spacing: 20) {
            let condition = weather.weather.first?.description ?? ""
            let iconName = WeatherHelper.mapConditionToSFSymbol(condition)

            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .symbolRenderingMode(.multicolor)

            Text(weather.name)
                .font(.title)
                .bold()

            let celsius = WeatherHelper.kelvinToCelsius(weather.main.temp)
            Text("\(celsius)°C")
                .font(.system(size: 40, weight: .bold))

            Text(condition.capitalized)
                .font(.headline)
        }
        .padding()
    }
}
