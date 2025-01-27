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
    @Published var isConnected: Bool = true

    private let weatherService: WeatherServiceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let cache: WeatherCacheProtocol
    private var cancellables = Set<AnyCancellable>()
    private var loadingWorkItem: DispatchWorkItem? = nil

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
        loadingWorkItem?.cancel()

        guard !city.isEmpty else {
            viewState = .emptyCity
            return
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.viewState = .loading
        }
        loadingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)

        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingWorkItem?.cancel()

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
                self.isConnected = isConnected
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
