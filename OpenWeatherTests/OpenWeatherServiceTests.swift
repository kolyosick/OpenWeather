//
//  OpenWeatherServiceTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import XCTest

final class OpenWeatherServiceTests: XCTestCase {
    private var mockNetworkService: MockNetworkService!
    private var mockURLFactory: MockURLFactory!
    private var mockCache: MockWeatherCache!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var weatherService: OpenWeatherService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockURLFactory = MockURLFactory()
        mockCache = MockWeatherCache()
        mockNetworkMonitor = MockNetworkMonitor()
        
        weatherService = OpenWeatherService(
            networkService: mockNetworkService,
            urlFactory: mockURLFactory,
            cache: mockCache,
            networkMonitor: mockNetworkMonitor
        )
    }

    override func tearDown() {
        mockNetworkService = nil
        mockURLFactory = nil
        mockCache = nil
        mockNetworkMonitor = nil
        weatherService = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        let mockService = MockNetworkService()
        let weatherResponse = WeatherResponse(
            name: "London",
            main: WeatherResponse.Main(temp: 288.55),
            weather: [WeatherResponse.Weather(description: "clear sky")]
        )
        let data = try! JSONEncoder().encode(weatherResponse)
        mockService.result = .success(data)

        let weatherService = OpenWeatherService(networkService: mockService,
                                                urlFactory: WeatherURLFactory(apiKey: "fake-key"))
        let expectation = XCTestExpectation(description: "Fetch weather success")

        weatherService.fetchWeather(for: "London") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, "London")
                XCTAssertEqual(response.main.temp, 288.55)
                XCTAssertEqual(response.weather.first?.description, "clear sky")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherFailure() {
        let mockService = MockNetworkService()
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let weatherService = OpenWeatherService(networkService: mockService,
                                                urlFactory: WeatherURLFactory(apiKey: "fake-key"))
        let expectation = XCTestExpectation(description: "Fetch weather failure")

        weatherService.fetchWeather(for: "London") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .notConnectedToInternet)
            default:
                XCTFail("Expected URLError, got different error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherInvalidURL() {
        // Use a factory with an invalid base URL
        struct MockWeatherURLFactory: WeatherURLFactoryProtocol {
            func makeWeatherURL(for city: String) -> URL? {
                return nil // Simulate failure
            }
        }

        let factory = MockWeatherURLFactory()
        let networkService = MockNetworkService()
        let service = OpenWeatherService(networkService: networkService, urlFactory: factory)
        let expectation = XCTestExpectation(description: "Invalid URL failure")

        service.fetchWeather(for: "InvalidCity") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                if let urlError = error as? URLError {
                    XCTAssertEqual(urlError.code, .badURL, "Expected URLError(.badURL)")
                } else {
                    XCTFail("Expected URLError(.badURL), got \(type(of: error)): \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherOfflineWithCachedData() {
        mockNetworkMonitor.isConnected = false // Simulate offline
        let cachedWeather = WeatherResponse(
            name: "Cached City",
            main: WeatherResponse.Main(temp: 20.0),
            weather: [WeatherResponse.Weather(description: "Cloudy")]
        )
        mockCache.cachedWeather = cachedWeather

        let expectation = XCTestExpectation(description: "Completion called with cached data")

        weatherService.fetchWeather(for: "AnyCity") { result in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.name, "Cached City")
                XCTAssertEqual(weather.main.temp, 20.0)
                XCTAssertEqual(weather.weather.first?.description, "Cloudy")
                XCTAssertFalse(self.mockNetworkService.fetchCalled, "Should not call network when offline with cached data")
            case .failure:
                XCTFail("Expected success, got failure instead")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherOfflineNoCachedDataReturnsError() {
        mockNetworkMonitor.isConnected = false // Simulate offline
        mockCache.cachedWeather = nil // No cached data
        let expectation = XCTestExpectation(description: "Completion called with failure")

        weatherService.fetchWeather(for: "AnyCity") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success instead")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .notConnectedToInternet)
                XCTAssertFalse(self.mockNetworkService.fetchCalled, "Should not call network when offline")
            default:
                XCTFail("Expected URLError(.notConnectedToInternet), got \(type(of: result))")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
