//
//  WeatherURLFactoryTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import XCTest

final class WeatherURLFactoryTests: XCTestCase {

    func testMakeWeatherURL() {
        let factory = WeatherURLFactory(apiKey: "testApiKey")
        let city = "London"

        guard let url = factory.makeWeatherURL(for: city) else {
            XCTFail("URL generation failed")
            return
        }

        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.openweathermap.org")
        XCTAssertEqual(url.path, "/data/2.5/weather")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems?.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }

        XCTAssertEqual(queryItems?["q"], city)
        XCTAssertEqual(queryItems?["appid"], "testApiKey")
    }
}
