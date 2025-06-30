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
    }
    
    @Published var weather: Weather?
    @Published var selectedLocation: Location = .japan
    
    func fetchWeather() async {
        let city = selectedLocation.rawValue
//        try! await Task.sleep(nanoseconds: 1_000_000) // 模擬的な遅延

        // モックデータ（APIで取得した形式に合わせて置き換え可能）
        // TODO: Implement the actual API call to fetch weather data.
        switch selectedLocation {
        case .japan:
            weather = Weather(locationName: "東京", description: "晴れ", tempMax: 30, tempMin: 22, precipitation: 10)
        case .usa:
            weather = Weather(locationName: "ニューヨーク", description: "くもり", tempMax: 25, tempMin: 18, precipitation: 40)
        case .uk:
            weather = Weather(locationName: "ロンドン", description: "雨", tempMax: 20, tempMin: 15, precipitation: 80)
        }
        
    }
    
    func switchLocation() async {
        guard let currentIndex = Location.allCases.firstIndex(of: selectedLocation) else { return }
        let nextIndex = (currentIndex + 1) % Location.allCases.count
        selectedLocation = Location.allCases[nextIndex]
        await fetchWeather()
    }
}
