//
//  WeatherViewModelTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import XCTest
import Combine

final class WeatherViewModelTests: XCTestCase {
    private var mockService: MockWeatherService!
    private var mockMonitor: MockNetworkMonitor!
    private var mockCache: MockWeatherCache!
    private var viewModel: WeatherViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        mockMonitor = MockNetworkMonitor()
        mockCache = MockWeatherCache()
        mockService.mockCache = mockCache
        viewModel = WeatherViewModel(weatherService: mockService,
                                     networkMonitor: mockMonitor,
                                     cache: mockCache)
        cancellables = []
    }

    override func tearDown() {
        mockService = nil
        mockMonitor = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchWeatherWithEmptyCity() {
        viewModel.city = ""
        viewModel.searchWeather()
        
        XCTAssertFalse(mockService.fetchWeatherCalled)
        XCTAssertEqual(viewModel.viewState, .emptyCity)
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
            XCTAssertEqual(self.viewModel.viewState, .normal, "Expected .none error state on success.")
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
            let expectedState = WeatherViewState.serviceError(mockError.localizedDescription)
            XCTAssertEqual(self.viewModel.viewState, expectedState)
            XCTAssertNil(self.viewModel.weather, "Weather should be nil on failure.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherCityNotFound() {
        viewModel.city = "InvalidCity"
        let mockError = NetworkError.notFound
        mockService.mockResult = .failure(mockError)

        let expectation = XCTestExpectation(description: "Fetch Weather shows city is not found")

        viewModel.searchWeather()

        DispatchQueue.main.async {
            let expectedState = WeatherViewState.serviceError(mockError.localizedDescription)
            XCTAssertEqual(self.viewModel.viewState, expectedState)

            if case let .serviceError(message) = self.viewModel.viewState {
                XCTAssertEqual(message, "City is not found")
                let localizedErrMsg = mockError.localizedDescription
                XCTAssertEqual(localizedErrMsg, "City is not found")
            } else {
                XCTFail("Expected .serviceError with \"City is not found\" message")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testSubscribeToNetworkChanges_LoadsCacheOnOffline() {
        let cachedWeather = WeatherResponse(
            name: "Cached City",
            main: WeatherResponse.Main(temp: 290.0),
            weather: [WeatherResponse.Weather(description: "cloudy")]
        )
        mockCache.cachedWeather = cachedWeather

        mockMonitor.isConnected = true
        XCTAssertEqual(viewModel.viewState, .normal, "Initially, the view state should be .normal")

        mockMonitor.sendConnectivity(false)

        let expectation = XCTestExpectation(description: "Offline triggers loadCacheIfAvailable")
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.weather?.name, "Cached City")
            XCTAssertEqual(self.viewModel.viewState, .normal, "Should show cached data in normal state")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCacheIfAvailable_WithCachedData() {

        let cachedWeather = WeatherResponse(
            name: "Cached City",
            main: WeatherResponse.Main(temp: 290.0),
            weather: [WeatherResponse.Weather(description: "cloudy")]
        )
        mockCache.cachedWeather = cachedWeather

        mockMonitor.sendConnectivity(false)
        let expectation = XCTestExpectation(description: "Offline triggers loadCacheIfAvailable")
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.weather?.name, "Cached City")
            XCTAssertEqual(self.viewModel.viewState, .normal)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCacheIfAvailable_WithoutCachedData() {
        mockCache.cachedWeather = nil

        mockMonitor.sendConnectivity(false)

        XCTAssertNil(viewModel.weather, "No weather available in the cache")
    }
}
