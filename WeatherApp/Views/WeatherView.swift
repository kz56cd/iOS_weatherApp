//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                if let url = viewModel.backgroundImageURL {
                    AsyncImage(url: url) {
                        $0.resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                    } placeholder: {
                        Color.clear
                    }
                } else {
                    Color.clear
                }

                // Main Content
                VStack {
                    if let weather = viewModel.weather {
                        
                        Label("\(weather.locationName)", systemImage: "mappin.circle")
                            .font(.title)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        List {
                            Label("天気: \(weather.description)", systemImage: "cloud.sun")
                            Label("最高気温: \(weather.tempMax, specifier: "%.1f")℃", systemImage: "thermometer.sun")
                            Label("最低気温: \(weather.tempMin, specifier: "%.1f")℃", systemImage: "thermometer.snowflake")
                            Label("降水確率: \(weather.precipitation)%", systemImage: "cloud.rain")
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden) // デフォルトの背景を非表示
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .padding()
                        
                    } else {
                        ProgressView("読み込み中...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Weather data will be displayed here.")
                            .padding()
                            .foregroundStyle(.white)
                    }
                    
                    Spacer(minLength: 100)
                    
                    Button(action: {
                        Task { await viewModel.switchLocation() }
                    }) {
                        Text("Switch Location")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .navigationTitle("Weather")
                .foregroundStyle(Color.black.opacity(0.5))
                .padding()
                .task {
                    await viewModel.fetchWeather()
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
