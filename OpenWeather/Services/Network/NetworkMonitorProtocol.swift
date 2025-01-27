//
//  NetworkMonitorProtocol.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation
import Combine

/// A protocol for monitoring network connectivity.
protocol NetworkMonitorProtocol {
    /// Indicates whether the network is currently reachable.
    var isConnected: Bool { get }

    /// A publisher that emits a `Bool` whenever connectivity changes.
    var connectivityPublisher: AnyPublisher<Bool, Never> { get }
}
