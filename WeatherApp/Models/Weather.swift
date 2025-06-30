//
//  Weather.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import Foundation

struct Weather: Decodable {
    var locationName: String
    let description: String
    let tempMax: Double
    let tempMin: Double
    let precipitation: Int

    enum CodingKeys: String, CodingKey {
        case daily
    }

    enum DailyCodingKeys: String, CodingKey {
        case weathercode
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationProbabilityMean = "precipitation_probability_mean"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dailyContainer = try container.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)

        let weatherCode = try dailyContainer.decode([Int].self, forKey: .weathercode).first ?? 0
        let tempMax = try dailyContainer.decode([Double].self, forKey: .temperature2mMax).first ?? 0.0
        let tempMin = try dailyContainer.decode([Double].self, forKey: .temperature2mMin).first ?? 0.0
        let precipitation = try dailyContainer.decode([Int].self, forKey: .precipitationProbabilityMean).first ?? 0

        self.locationName = "" // This will be set in the ViewModel
        self.description = Weather.description(for: weatherCode)
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.precipitation = precipitation
    }

    // Initializer for mock data
    init(locationName: String, description: String, tempMax: Double, tempMin: Double, precipitation: Int) {
        self.locationName = locationName
        self.description = description
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.precipitation = precipitation
    }

    static func description(for code: Int) -> String {
        switch code {
        case 0: return "晴れ"
        case 1, 2, 3: return "一部曇り"
        case 45, 48: return "霧"
        case 51, 53, 55: return "霧雨"
        case 56, 57: return "凍える霧雨"
        case 61, 63, 65: return "雨"
        case 66, 67: return "凍える雨"
        case 71, 73, 75: return "雪"
        case 77: return "霧雪"
        case 80, 81, 82: return "にわか雨"
        case 85, 86: return "にわか雪"
        case 95: return "雷雨"
        case 96, 99: return "ひょうを伴う雷雨"
        default: return "不明"
        }
    }
}
