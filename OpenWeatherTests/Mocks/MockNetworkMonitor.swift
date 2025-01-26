//
//  MockNetworkMonitor.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation
import Combine

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true

    // Use a PassthroughSubject to emit connectivity changes
    private let connectivitySubject = PassthroughSubject<Bool, Never>()
    var connectivityPublisher: AnyPublisher<Bool, Never> {
        connectivitySubject.eraseToAnyPublisher()
    }

    func sendConnectivity(_ isConnected: Bool) {
        self.isConnected = isConnected
        connectivitySubject.send(isConnected)
    }
}
