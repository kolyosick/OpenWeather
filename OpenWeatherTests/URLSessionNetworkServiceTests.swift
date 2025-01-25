//
//  URLSessionNetworkServiceTests.swift
//  URLSessionNetworkServiceTests
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import XCTest
@testable import OpenWeather

import XCTest

final class URLSessionNetworkServiceTests: XCTestCase {
    var networkService: URLSessionNetworkService!
    var session: URLSession!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)

        networkService = URLSessionNetworkService(session: session)
    }

    override func tearDown() {
        networkService = nil
        session = nil
        super.tearDown()
    }

    func testFetchSuccess() {
        let expectedResponse = WeatherResponse(
            name: "Test City",
            main: WeatherResponse.Main(temp: 300.0),
            weather: [WeatherResponse.Weather(description: "sunny")]
        )
        let mockData = try! JSONEncoder().encode(expectedResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.mockResponse = (data: mockData, response: mockURLResponse, error: nil)

        let expectation = XCTestExpectation(description: "Fetch success")

        networkService.fetch(WeatherResponse.self, from: URL(string: "https://mockurl.com")!) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, expectedResponse.name)
                XCTAssertEqual(response.main.temp, expectedResponse.main.temp)
                XCTAssertEqual(response.weather.first?.description, expectedResponse.weather.first?.description)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchFailure() {
        let mockError = URLError(.timedOut)
        MockURLProtocol.mockResponse = (data: nil, response: nil, error: mockError)

        let expectation = XCTestExpectation(description: "Fetch failure")

        networkService.fetch(WeatherResponse.self, from: URL(string: "https://mockurl.com")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .timedOut)
            default:
                XCTFail("Expected URLError, got a different error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testInvalidResponse() {
        let mockData = Data()
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.mockResponse = (data: mockData, response: mockURLResponse, error: nil)

        let expectation = XCTestExpectation(description: "Invalid response failure")

        networkService.fetch(WeatherResponse.self, from: URL(string: "https://mockurl.com")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .badServerResponse)
            default:
                XCTFail("Expected URLError, got a different error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchNilData() {
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.mockResponse = (data: nil, response: mockURLResponse, error: nil)

        let expectation = XCTestExpectation(description: "Nil data failure")

        networkService.fetch(WeatherResponse.self, from: URL(string: "https://mockurl.com")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                if let urlError = error as? URLError {
                    XCTAssertEqual(urlError.code, .cannotDecodeContentData, "Expected cannotDecodeContentData error")
                } else {
                    XCTFail("Expected URLError(.cannotDecodeContentData), got \(type(of: error)): \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchDecodingFailure() {
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let invalidJSONData = "Invalid JSON".data(using: .utf8)

        MockURLProtocol.mockResponse = (data: invalidJSONData, response: mockURLResponse, error: nil)

        let expectation = XCTestExpectation(description: "Decoding failure")

        networkService.fetch(WeatherResponse.self, from: URL(string: "https://mockurl.com")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                // Ensure the error is DecodingError
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        XCTAssertNotNil(context, "Expected a context for corrupted data")
                    default:
                        XCTFail("Unexpected DecodingError type: \(decodingError)")
                    }
                } else {
                    XCTFail("Expected DecodingError, got \(type(of: error)): \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

}
