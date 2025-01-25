//
//  NetworkService.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 25.01.25.
//

import Foundation

protocol NetworkService {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>) -> Void)
}
