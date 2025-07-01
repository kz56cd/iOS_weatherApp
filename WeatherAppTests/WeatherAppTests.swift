//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Masakazu Sano on 2025/07/01.
//

import Foundation
import Testing
@testable import WeatherApp
import Moya

struct WeatherViewModelTests {

    var viewModel: WeatherViewModel!
    var mockProvider: MoyaProvider<WeatherAPIService>!

    @Test func testSwitchLocation() async throws {
        let viewModel = await WeatherViewModel()
        #expect(await viewModel.selectedLocation == .japan)

        let allLocations = WeatherViewModel.Location.allCases
        for i in 1..<allLocations.count {
            await viewModel.switchLocation()
            #expect(await viewModel.selectedLocation == allLocations[i])
        }
        // After cycling through all, it should return to the first one
        await viewModel.switchLocation()
        #expect(await viewModel.selectedLocation == allLocations[0])
    }

    @Test func testFetchWeather_Success() async throws {
        let mockResponse = """
        {
            "daily": {
                "weathercode": [3],
                "temperature_2m_max": [25.0],
                "temperature_2m_min": [15.0],
                "precipitation_probability_mean": [20]
            }
        }
        """.data(using: .utf8)!

        let endpointClosure = { (target: WeatherAPIService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200, mockResponse) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }

        let mockProvider = MoyaProvider<WeatherAPIService>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let viewModel = await WeatherViewModel(provider: mockProvider)

        await viewModel.fetchWeather()

        let weather = await viewModel.weather
        #expect(weather != nil)
        #expect(weather?.locationName == "東京")
        #expect(weather?.description == "一部曇り")
        #expect(weather?.tempMax == 25.0)
        #expect(weather?.tempMin == 15.0)
        #expect(weather?.precipitation == 20)
    }
}
