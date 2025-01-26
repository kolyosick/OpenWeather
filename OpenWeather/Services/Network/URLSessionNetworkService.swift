//
//  URLSessionNetworkService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

final class URLSessionNetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                break // OK – proceed to decode
            case 404:
                completion(.failure(NetworkError.notFound))
                return
            default:
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
