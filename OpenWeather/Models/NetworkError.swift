//
//  NetworkError.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "City is not found"
        }
    }

    var localizedDescription: String? {
        switch self {
        case .notFound:
            //TODO: Localisation
            return "City is not found"
        }
    }
}
