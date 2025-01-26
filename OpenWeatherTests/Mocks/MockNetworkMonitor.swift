//
//  MockNetworkMonitor.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import Foundation

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true
}
