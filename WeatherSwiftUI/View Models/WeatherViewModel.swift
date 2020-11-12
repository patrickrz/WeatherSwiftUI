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

class WeatherViewModel: ObservableObject {
    
    @Published private var weather: Weather?
    @Published var errorMessage: String = ""
    @Published var loadingState: LoadingState = .firstTime
    @Published var temperatureUnit: TemperatureUnit = .fahrenheit
    
    var temperature: Double {
        guard let temp = weather?.temp else {
            return 0.0
        }
        return temp
    }
    
    var feelLike: Double {
        guard let feels_like = weather?.feels_like else {
            return 0.0
        }
        return feels_like
    }
    
    var minTemp: Double {
        guard let temp_min = weather?.temp_min else {
            return 0.0
        }
        return temp_min
    }
    
    var maxTemp: Double {
        guard let temp_max = weather?.temp_max else {
            return 0.0
        }
        return temp_max
    }
    
    var pressureVal: Double {
        guard let pressure = weather?.pressure else {
            return 0.0
        }
        return pressure
    }
    
    var humidityVal: Double {
        guard let humidity = weather?.humidity else {
            return 0.0
        }
        return humidity
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
