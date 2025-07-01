//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import Foundation
import Moya

@MainActor
class WeatherViewModel: ObservableObject {
    enum Location: String, CaseIterable {
        case japan = "Tokyo"
        case usa = "New York"
        case uk = "London"
        case china = "Beijing"
        case france = "Paris"
        case germany = "Berlin"
        case australia = "Sydney"
        case brazil = "Rio de Janeiro"

        var latitude: Double {
            switch self {
            case .japan: return 35.6895
            case .usa: return 40.7128
            case .uk: return 51.5074
            case .china: return 39.9042
            case .france: return 48.8566
            case .germany: return 52.5200
            case .australia: return -33.8688
            case .brazil: return -22.9068
            }
        }

        var longitude: Double {
            switch self {
            case .japan: return 139.6917
            case .usa: return -74.0060
            case .uk: return -0.1278
            case .china: return 116.4074
            case .france: return 2.3522
            case .germany: return 13.4050
            case .australia: return 151.2093
            case .brazil: return -43.1729
            }
        }
        
        var locationName: String {
            switch self {
            case .japan: return "東京"
            case .usa: return "ニューヨーク"
            case .uk: return "ロンドン"
            case .china: return "北京"
            case .france: return "パリ"
            case .germany: return "ベルリン"
            case .australia: return "シドニー"
            case .brazil: return "リオデジャネイロ"
            }
        }

        var timezone: String {
            switch self {
            case .japan: return "Asia/Tokyo"
            case .usa: return "America/New_York"
            case .uk: return "Europe/London"
            case .china: return "Asia/Shanghai"
            case .france: return "Europe/Paris"
            case .germany: return "Europe/Berlin"
            case .australia: return "Australia/Sydney"
            case .brazil: return "America/Sao_Paulo"
            }
        }
    }

    @Published var weather: Weather?
    @Published var selectedLocation: Location = .japan

    private let provider: MoyaProvider<WeatherAPIService>

    init(provider: MoyaProvider<WeatherAPIService> = MoyaProvider<WeatherAPIService>()) {
        self.provider = provider
    }

    @Published var backgroundImageURL: URL?

    private let unsplashService = UnsplashService()

    func fetchWeather() async {
        // Reset state before fetching to ensure a clean loading state
        self.weather = nil
        self.backgroundImageURL = nil

        async let weatherResult = fetchWeatherData()
        async let imageURLResult = fetchBackgroundImage()

        // Await both results concurrently and then update the state once.
        let (weatherData, imageURL) = await (weatherResult, imageURLResult)
        self.weather = weatherData
        self.backgroundImageURL = imageURL
        
        print("self.weather: ", self.weather)
        
    }

    private func fetchWeatherData() async -> Weather? {
        do {
            let response = try await provider.request(.getWeather(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude, timezone: selectedLocation.timezone))
            var decodedWeather = try JSONDecoder().decode(Weather.self, from: response.data)
            decodedWeather.locationName = selectedLocation.locationName
            return decodedWeather
        } catch {
            print("Error fetching or decoding weather data: \(error)")
            return nil
        }
    }

    private func fetchBackgroundImage() async -> URL? {
        do {
            return try await unsplashService.fetchImage(for: selectedLocation.rawValue)
        } catch {
            print("Error fetching background image: \(error)")
            return nil
        }
    }
    
    func switchLocation() async {
        guard let currentIndex = Location.allCases.firstIndex(of: selectedLocation) else { return }
        let nextIndex = (currentIndex + 1) % Location.allCases.count
        selectedLocation = Location.allCases[nextIndex]
        await fetchWeather()
    }
}
