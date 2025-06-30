//
//  Weather.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import Foundation

struct Weather: Decodable {
    let locationName: String
    let description: String
    let tempMax: Double
    let tempMin: Double
    let precipitation: Int // %
}
