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
            let icon = weather.weather.first?.icon ?? ""
            let iconName = WeatherHelper.mapIconToSFSymbol(icon)

            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .symbolRenderingMode(.hierarchical)

            Text(weather.name)
                .font(.title)
                .bold()

            let celsius = WeatherHelper.kelvinToCelsius(weather.main.temp)
            Text("\(celsius)°C")
                .font(.system(size: 40, weight: .bold))

            let condition = weather.weather.first?.description ?? ""
            Text(condition.capitalized)
                .font(.headline)
        }
        .padding()
    }
}
