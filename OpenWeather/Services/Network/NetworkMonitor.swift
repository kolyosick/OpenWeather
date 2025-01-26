//
//  NetworkMonitor.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Network
import Combine

final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: Constants.networkMonitorKey)

    @Published private(set) var isConnected: Bool = true
    var connectivityPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
