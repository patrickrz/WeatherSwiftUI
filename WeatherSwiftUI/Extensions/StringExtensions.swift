//
//  StringExtensions.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import Foundation

extension String {

    func spaceCheck() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
