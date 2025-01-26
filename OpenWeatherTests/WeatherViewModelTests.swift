//
//  WeatherViewModelTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import XCTest

final class WeatherViewModelTests: XCTestCase {
    private var mockService: MockWeatherService!
    private var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
    }

    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }

    func testSearchWeatherWithEmptyCity() {
        viewModel.city = ""
        viewModel.searchWeather()
        
        XCTAssertFalse(mockService.fetchWeatherCalled)
        XCTAssertEqual(viewModel.errorState, .emptyCity)
        XCTAssertNil(viewModel.weather)
    }

    func testFetchWeatherSuccess() {
        viewModel.city = "London"
        let mockWeather = WeatherResponse(
            name: "London",
            main: WeatherResponse.Main(temp: 300.0),
            weather: [WeatherResponse.Weather(description: "clear sky")]
        )
        mockService.mockResult = .success(mockWeather)

        let expectation = XCTestExpectation(description: "Fetch Weather Succeeds")

        viewModel.searchWeather()

        XCTAssertTrue(mockService.fetchWeatherCalled, "fetchWeather should be called for non-empty city.")

        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.errorState, .none, "Expected .none error state on success.")
            XCTAssertEqual(self.viewModel.weather?.name, "London", "Expected weather for London on success.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherFailure() {
        viewModel.city = "InvalidCity"
        let mockError = URLError(.badServerResponse)
        mockService.mockResult = .failure(mockError)

        let expectation = XCTestExpectation(description: "Fetch Weather Fails")

        viewModel.searchWeather()

        XCTAssertTrue(mockService.fetchWeatherCalled, "fetchWeather should be called for non-empty city.")

        DispatchQueue.main.async {
            let expectedState = WeatherErrorState.serviceError(mockError.localizedDescription)
            XCTAssertEqual(self.viewModel.errorState, expectedState)
            XCTAssertNil(self.viewModel.weather, "Weather should be nil on failure.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
