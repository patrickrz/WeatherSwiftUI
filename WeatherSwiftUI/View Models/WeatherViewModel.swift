//
//  WeatherViewModel.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import Foundation

enum LoadingState {
    case loading
    case success
    case failed
    case firstTime
}

enum TemperatureUnit: String, CaseIterable {
    case fahrenheit
    case celcius
}

extension TemperatureUnit {
    var title: String {
        switch self {
            case .fahrenheit:
                return "Fahrenheit"
            case .celcius:
                return "Celcius"
        }
    }
}

class WeatherViewModel: ObservableObject {
    
    @Published private var weather: Weather?
    @Published var errorMessage: String = ""
    @Published var loadingState: LoadingState = .firstTime
    @Published var temperatureUnit: TemperatureUnit = .fahrenheit
    private let locationManager = LocationManager()
    
    var temperature: String {
        guard let temp = weather?.temp else {
            return "--"
        }
        switch temperatureUnit {
            case .fahrenheit:
                return String(format: "%.0F°F", temp.toFahrenheit())
            case .celcius:
                return String(format: "%.0F°C", temp.toCelsius())
        }
    }
    
    var feelLike: String {
        guard let feels_like = weather?.feels_like else {
            return "--"
        }
        switch temperatureUnit {
            case .fahrenheit:
                return String(format: "%.0F°F", feels_like.toFahrenheit())
            case .celcius:
                return String(format: "%.0F°C", feels_like.toCelsius())
        }
    }
    
    var minTemp: String {
        guard let temp_min = weather?.temp_min else {
            return "--"
        }
        switch temperatureUnit {
            case .fahrenheit:
                return String(format: "%.0F°", temp_min.toFahrenheit())
            case .celcius:
                return String(format: "%.0F°", temp_min.toCelsius())
        }
    }
    
    var maxTemp: String {
        guard let temp_max = weather?.temp_max else {
            return "--"
        }
        switch temperatureUnit {
            case .fahrenheit:
                return String(format: "%.0F°", temp_max.toFahrenheit())
            case .celcius:
                return String(format: "%.0F°", temp_max.toCelsius())
        }
    }
    
//    var pressureVal: Double {
//        guard let pressure = weather?.pressure else {
//            return 0.0
//        }
//        return pressure
//    }
//
    var humidityVal: String {
        guard let humidity = weather?.humidity else {
            return "--"
        }
        return String(format: "%.0F%%", humidity)
    }
    
    func fetchInitial() -> String {
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            return "Error: exposedLocation is nil"
        }
        
        var returnString = ""
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            
            
            if let town = placemark.locality {
                returnString = returnString + "\(town)"
                
            }
        }
        return returnString
    }

    
    func fetchWeather(city: String) {
        
        guard let city = city.spaceCheck() else {
            DispatchQueue.main.async {
                self.errorMessage = "City is incorrect"
            }
            return
        }
        
        self.loadingState = .loading
        
        WeatherService().getWeather(city: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weather = weather
                    self.loadingState = .success
                }
                
            case .failure(_ ):
                DispatchQueue.main.async {
                    self.errorMessage = "Location not found"
                    self.loadingState = .failed
                }
                
            }
        }
    }

    
}
