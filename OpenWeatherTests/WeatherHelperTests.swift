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

    func testClearSkyMapsToSunMaxFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("clear sky")
        XCTAssertEqual(icon, "sun.max.fill")
    }
    
    func testFewCloudsMapsToCloudSunFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("few clouds")
        XCTAssertEqual(icon, "cloud.sun.fill")
    }
    
    func testScatteredCloudsMapsToCloudFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("scattered clouds")
        XCTAssertEqual(icon, "cloud.fill")
    }
    
    func testBrokenCloudsMapsToSmokeFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("broken clouds")
        XCTAssertEqual(icon, "smoke.fill")
    }
    
    func testShowerRainMapsToCloudDrizzleFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("shower rain")
        XCTAssertEqual(icon, "cloud.drizzle.fill")
    }
    
    func testRainMapsToCloudRainFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("rain")
        XCTAssertEqual(icon, "cloud.rain.fill")
    }
    
    func testThunderstormMapsToCloudBoltRainFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("thunderstorm")
        XCTAssertEqual(icon, "cloud.bolt.rain.fill")
    }
    
    func testSnowMapsToCloudSnowFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("snow")
        XCTAssertEqual(icon, "cloud.snow.fill")
    }
    
    func testMistMapsToCloudFogFill() {
        let icon = WeatherHelper.mapConditionToSFSymbol("mist")
        XCTAssertEqual(icon, "cloud.fog.fill")
    }
    
    func testFallbackConditionMapsToCloud() {
        let icon = WeatherHelper.mapConditionToSFSymbol("some unknown weather")
        XCTAssertEqual(icon, "cloud", "Unrecognized conditions should map to 'cloud'")
    }
}
