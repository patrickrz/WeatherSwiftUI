//
//  URL+Extensions.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import Foundation

extension URL {
    
    static func urlForWeather() -> URL? {
        guard let url = URL(string:
        "http://api.openweathermap.org/data/2.5/weather?q=london&appid=cb1e830d664d7c1dffa273845dcb2804")
        else {
            return nil
        }
        return url
    }
}
