//
//  WeatherDetailViewTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 27.01.25.
//

import XCTest
import ViewInspector
import SwiftUI

class WeatherDetailViewTests: XCTestCase {

    func test_weatherDetailView_content() throws {
        let weather = WeatherResponse(
            name: "Paris",
            main: .init(temp: 300.0),
            weather: [.init(description: "sunny", icon: "01d")]
        )
        let view = WeatherDetailView(weather: weather)
        let vStack = try view.inspect().find(ViewType.VStack.self)
        let image = try vStack.image(0)
        let cityName = try vStack.text(1).string()
        let temperature = try vStack.text(2).string()

        XCTAssertNotNil(image)
        XCTAssertEqual(cityName, "Paris")
        XCTAssertEqual(temperature, "\(WeatherHelper.kelvinToCelsius(300.0))°C")
    }
}
