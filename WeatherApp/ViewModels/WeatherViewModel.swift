//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    enum Location: String, CaseIterable {
        case japan = "Tokyo"
        case usa = "New York"
        case uk = "London"

        var latitude: Double {
            switch self {
            case .japan: return 35.6895
            case .usa: return 40.7128
            case .uk: return 51.5074
            }
        }

        var longitude: Double {
            switch self {
            case .japan: return 139.6917
            case .usa: return -74.0060
            case .uk: return -0.1278
            }
        }
        
        var locationName: String {
            switch self {
            case .japan: return "東京"
            case .usa: return "ニューヨーク"
            case .uk: return "ロンドン"
            }
        }
    }

    @Published var weather: Weather?
    @Published var selectedLocation: Location = .japan

    func fetchWeather() async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(selectedLocation.latitude)&longitude=\(selectedLocation.longitude)&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_mean&timezone=Asia%2FTokyo"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            var decodedWeather = try JSONDecoder().decode(Weather.self, from: data)
            decodedWeather.locationName = selectedLocation.locationName
            weather = decodedWeather
        } catch {
            print("Error fetching or decoding weather data: \(error)")
        }
    }
    
    func switchLocation() async {
        guard let currentIndex = Location.allCases.firstIndex(of: selectedLocation) else { return }
        let nextIndex = (currentIndex + 1) % Location.allCases.count
        selectedLocation = Location.allCases[nextIndex]
        await fetchWeather()
    }
}
