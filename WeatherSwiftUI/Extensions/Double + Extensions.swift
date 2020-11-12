//
//  Double + Extensions.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/12/20.
//

import Foundation

extension Double {
    
    func toFahrenheit() -> Double {
            // current temperature is always in Kelvin
            let temperature = Measurement<UnitTemperature>(value: self, unit: .kelvin)
            // convert to fahrenheit from Kelvin
            let convertedTemperature = temperature.converted(to: .fahrenheit)
            return convertedTemperature.value
        }
        
        func toCelsius() -> Double {
            // current temperature is always in Kelvin
            let temperature = Measurement<UnitTemperature>(value: self, unit: .kelvin)
            // convert to fahrenheit from Kelvin
            let convertedTemperature = temperature.converted(to: .celsius)
            return convertedTemperature.value
        }
    
    
}
