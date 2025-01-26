//
//  WeatherCacheTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import XCTest

final class WeatherCacheTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var cache: WeatherCache!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "TestSuite-WeatherCache")
        userDefaults.removePersistentDomain(forName: "TestSuite-WeatherCache")

        cache = WeatherCache(userDefaults: userDefaults, cacheKey: "lastWeatherData")
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "TestSuite-WeatherCache")
        userDefaults = nil
        cache = nil
        super.tearDown()
    }

    func testSaveAndLoadWeather() {
        let weather = WeatherResponse(
            name: "Test City",
            main: WeatherResponse.Main(temp: 25.0),
            weather: [WeatherResponse.Weather(description: "Sunny")]
        )

        cache.save(weather: weather)
        let loadedWeather = cache.load()

        XCTAssertNotNil(loadedWeather, "Expected to load a valid WeatherResponse")
        XCTAssertEqual(loadedWeather?.name, "Test City")
        XCTAssertEqual(loadedWeather?.main.temp, 25.0)
        XCTAssertEqual(loadedWeather?.weather.first?.description, "Sunny")
    }

    func testLoadWithNoData() {
        let loadedWeather = cache.load()

        XCTAssertNil(loadedWeather, "Expected nil when user defaults has no weather data")
    }

    func testLoadCorruptedData() {
        let corruptedData = "Corrupted Data".data(using: .utf8)!
        userDefaults.set(corruptedData, forKey: "lastWeatherData")

        let loadedWeather = cache.load()

        XCTAssertNil(loadedWeather, "Expected load to fail and return nil for corrupted data")
    }
}
