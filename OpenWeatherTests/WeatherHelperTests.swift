//
//  WeatherHelperTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import XCTest

final class WeatherHelperTests: XCTestCase {

    func testKelvinToCelsiusPositiveTemperature() {
        let kelvin: Double = 300
        let celsius = WeatherHelper.kelvinToCelsius(kelvin)
        XCTAssertEqual(celsius, 26, "300 K should convert to roughly 26 °C")
    }

    func testKelvinToCelsiusNegativeTemperature() {
        let kelvin: Double = 250
        let celsius = WeatherHelper.kelvinToCelsius(kelvin)
        XCTAssertEqual(celsius, -23, "250 K should convert to roughly -23 °C")
    }

    func testIconToSFSymbolMapping() {
        let testCases: [(input: String, expected: String)] = [
            // Clear Sky
            ("01d", "sun.max.fill"),
            ("01n", "moon.stars.fill"),

            // Few Clouds
            ("02d", "cloud.sun.fill"),
            ("02n", "cloud.moon.fill"),

            // Scattered Clouds
            ("03d", "cloud.fill"),
            ("03n", "cloud.fill"),

            // Broken Clouds
            ("04d", "smoke.fill"),
            ("04n", "smoke.fill"),

            // Shower Rain
            ("09d", "cloud.drizzle.fill"),
            ("09n", "cloud.drizzle.fill"),

            // Rain
            ("10d", "cloud.rain.fill"),
            ("10n", "cloud.moon.rain.fill"),

            // Thunderstorm
            ("11d", "cloud.bolt.rain.fill"),
            ("11n", "cloud.bolt.rain.fill"),

            // Snow
            ("13d", "cloud.snow.fill"),
            ("13n", "cloud.snow.fill"),

            // Mist
            ("50d", "cloud.fog.fill"),
            ("50n", "cloud.fog.fill")
        ]
        
        for (icon, expected) in testCases {
            let result = WeatherHelper.mapIconToSFSymbol(icon)
            XCTAssertEqual(result, expected,
                           "Failed for icon: \(icon). Expected: \(expected), Got: \(result)")
        }
    }

    func testFallbackConditionMapsToCloud() {
        let icon = WeatherHelper.mapIconToSFSymbol("some unknown icon")
        XCTAssertEqual(icon, "cloud", "Unrecognized conditions should map to 'cloud'")
    }
}
