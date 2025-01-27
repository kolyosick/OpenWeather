//
//  WeatherViewTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 27.01.25.
//

import XCTest
import ViewInspector
import SwiftUI

class WeatherViewTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockMonitor: MockNetworkMonitor!
    var mockService: MockWeatherService!
    var mockCache: MockWeatherCache!

    override func setUp() {
        super.setUp()
        mockMonitor = MockNetworkMonitor()
        mockService = MockWeatherService()
        mockCache = MockWeatherCache()
        viewModel = WeatherViewModel(
            weatherService: mockService,
            networkMonitor: mockMonitor,
            cache: mockCache
        )
    }

    func test_offlineNotice_visibility() throws {
        viewModel.isConnected = false

        let view = WeatherView(viewModel: viewModel)
        let offlineNotice = try view.inspect().find(OfflineNotice.self)

        XCTAssertNotNil(offlineNotice)
    }

    func test_onlineState_hidesOfflineNotice() throws {
        viewModel.isConnected = true

        let view = WeatherView(viewModel: viewModel)

        XCTAssertThrowsError(try view.inspect().find(OfflineNotice.self))
    }

    func test_loadingState_showsProgressView() throws {
        viewModel.viewState = .loading

        let view = WeatherView(viewModel: viewModel)

        let progress = try view.inspect().find(ViewType.ProgressView.self)
        XCTAssertNotNil(progress)

        let text = try progress.find(ViewType.Text.self).string()
        XCTAssertEqual(text, Message.fetchingWeather)
    }

    func test_emptyCityState_showsErrorMessage() throws {
        viewModel.viewState = .emptyCity

        let view = WeatherView(viewModel: viewModel)
        let text = try view.inspect().find(text: Message.enterCityName)

        XCTAssertNotNil(text)
        XCTAssertEqual(try text.string(), Message.enterCityName)
        XCTAssertEqual(try text.attributes().foregroundColor(), Color.red)
    }

    func test_serviceErrorState_showsErrorMessage() throws {
        let errorMessage = "Test error"
        viewModel.viewState = .serviceError(errorMessage)

        let view = WeatherView(viewModel: viewModel)
        let text = try view.inspect().find(text: errorMessage)

        XCTAssertNotNil(text)
        XCTAssertEqual(try text.string(), errorMessage)
        XCTAssertEqual(try text.attributes().foregroundColor(), Color.red)
    }

    func test_normalState_withWeatherData_showsDetailView() throws {
        viewModel.weather = WeatherResponse(
            name: "London",
            main: .init(temp: 290.0),
            weather: [.init(description: "cloudy", icon: "01d")]
        )

        let view = WeatherView(viewModel: viewModel)
        let detailView = try view.inspect().find(WeatherDetailView.self)

        XCTAssertNotNil(detailView)
    }
}
