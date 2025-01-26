//
//  MockNetworkService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var fetchCalled = false
    var result: Result<Data, Error>?

    func fetch<T>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        fetchCalled = true
        guard let result = result else {
            completion(.failure(URLError(.unknown)))
            return
        }

        switch result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
