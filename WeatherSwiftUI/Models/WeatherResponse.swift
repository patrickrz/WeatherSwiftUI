//
//  WeatherResponse.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: Weather
    let name: String
}

struct Weather: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

