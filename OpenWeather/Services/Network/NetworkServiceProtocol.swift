//
//  NetworkServiceProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

/// A protocol defining a generic network service for fetching decodable data.
protocol NetworkServiceProtocol {
    /// Performs a network fetch for a specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - type: The `Decodable` type to which the fetched data should be decoded.
    ///   - url: The `URL` from which to request data.
    ///   - completion: A closure to be called with the result, either a successfully decoded object or an `Error`.
    func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
