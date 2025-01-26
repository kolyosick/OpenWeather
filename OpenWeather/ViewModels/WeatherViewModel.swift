//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 26.01.25.
//

import SwiftUI
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: WeatherResponse?
    @Published var viewState: WeatherViewState = .normal

    private let weatherService: WeatherServiceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let cache: WeatherCacheProtocol
    private var cancellables = Set<AnyCancellable>()

    init(weatherService: WeatherServiceProtocol,
         networkMonitor: NetworkMonitorProtocol,
         cache: WeatherCacheProtocol) {
        self.weatherService = weatherService
        self.networkMonitor = networkMonitor
        self.cache = cache
        subscribeToNetworkChanges()
    }
    
    func searchWeather() {
        viewState = .normal

        guard !city.isEmpty else {
            viewState = .emptyCity
            return
        }

        viewState = .loading

        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.weather = response
                    self?.viewState = .normal
                case .failure(let error):
                    self?.weather = nil
                    self?.viewState = .serviceError(error.localizedDescription)
                }
            }
        }
    }

    private func subscribeToNetworkChanges() {
        networkMonitor.connectivityPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if !isConnected {
                    self.loadCacheIfAvailable()
                }
            }
            .store(in: &cancellables)
    }

    private func loadCacheIfAvailable() {
        if let cached = cache.load() {
            self.weather = cached
        } else {
            self.weather = nil
        }
    }
}
