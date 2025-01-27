# Weather App

A simple SwiftUI-based weather application that fetches data from the [OpenWeatherMap](https://openweathermap.org/) API and displays current weather information for a given city.

## Features

- **Public Weather API**: Uses [OpenWeatherMap](https://openweathermap.org/) to retrieve weather data.
  - The current API key is located in `Helpers/Constants.swift`.
- **SwiftUI UI**: All interface elements are built with SwiftUI.
- **City Search**: A search bar lets users enter a city name, then the app fetches and displays:
  - **Weather Condition Icon** (SF Symbols)
  - **Temperature**  
  - **Weather Condition**  
- **SF Symbols for Icons**: Provides an iOS-native look and feel.
- **Error Handling**:
  - Shows an error message if the city is not found or if there’s an API/network issue.
- **Offline Caching**:
  - Saves the last fetched weather data locally.
  - Displays cached data if the user opens the app offline.
- **Offline Notice**: Informs the user that the app is offline if no internet connection is detected.
- **Device Support**: Works on **all iOS devices**, including iPad.
- **High Test Coverage**: ~99% coverage across:
  - **Unit Tests** for business logic.
  - **SwiftUI View Tests** using [ViewInspector](https://github.com/nalexn/ViewInspector).

## Getting Started

1. **Clone** the repository:  
   ```bash
   git clone https://github.com/kolyosick/OpenWeather.git
   ```

2. **Open** `WeatherApp.xcodeproj` in Xcode.

3. **Set** your [OpenWeatherMap](https://openweathermap.org/) API key:
   - In `Helpers/Constants.swift`, replace current API key with your own.

4. **Build & Run** on a device or simulator.  
   - Use the search bar to look up any city’s weather.
