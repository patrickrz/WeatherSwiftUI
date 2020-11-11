//
//  WeatherService.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import Foundation

enum NetworkError: Error {
    case badURl
    case noData
    case decodingError
}

class WeatherService {
    func getWeather(city: String, completion: @escaping(Result<Weather?, NetworkError>) -> Void) {
        guard let url = URL.urlForWeather(city) else {
            return completion(.failure(.badURl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            if let weatherResponse = weatherResponse {
                return completion(.success(weatherResponse.main))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
