//
//  NameService.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/12/20.
//

import Foundation

enum NetworkError1: Error {
    case badURl
    case noData
    case decodingError
}

class NameService {
    func getName(city: String, completion: @escaping(Result<SysModel?, NetworkError1>) -> Void) {
            guard let url = URL.urlForWeather(city) else {
                return completion(.failure(.badURl))
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return completion(.failure(.noData))
                }
                let nameResponse = try? JSONDecoder().decode(NameResponse.self, from: data)
                if let nameResponse = nameResponse {
                    return completion(.success(nameResponse.name))
                } else {
                    completion(.failure(.decodingError))
                }
            }.resume()
        }
}
