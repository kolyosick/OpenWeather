//
//  SFWeatherMapperTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import XCTest

final class SFWeatherMapperTests: XCTestCase {
    
    func testClearSkyMapsToSunMaxFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("clear sky")
        XCTAssertEqual(icon, "sun.max.fill")
    }
    
    func testFewCloudsMapsToCloudSunFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("few clouds")
        XCTAssertEqual(icon, "cloud.sun.fill")
    }
    
    func testScatteredCloudsMapsToCloudFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("scattered clouds")
        XCTAssertEqual(icon, "cloud.fill")
    }
    
    func testBrokenCloudsMapsToSmokeFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("broken clouds")
        XCTAssertEqual(icon, "smoke.fill")
    }
    
    func testShowerRainMapsToCloudDrizzleFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("shower rain")
        XCTAssertEqual(icon, "cloud.drizzle.fill")
    }
    
    func testRainMapsToCloudRainFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("rain")
        XCTAssertEqual(icon, "cloud.rain.fill")
    }
    
    func testThunderstormMapsToCloudBoltRainFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("thunderstorm")
        XCTAssertEqual(icon, "cloud.bolt.rain.fill")
    }
    
    func testSnowMapsToCloudSnowFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("snow")
        XCTAssertEqual(icon, "cloud.snow.fill")
    }
    
    func testMistMapsToCloudFogFill() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("mist")
        XCTAssertEqual(icon, "cloud.fog.fill")
    }
    
    func testFallbackConditionMapsToCloud() {
        let icon = SFWeatherMapper.mapConditionToSFSymbol("some unknown weather")
        XCTAssertEqual(icon, "cloud", "Unrecognized conditions should map to 'cloud'")
    }
}
