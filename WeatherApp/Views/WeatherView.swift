//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showingSettingsSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                if let url = viewModel.backgroundImageURL {
                    AsyncImage(url: url) {
                        phase in
                        switch phase {
                        case .empty:
                            Color.gray // Stable background during loading
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .containerRelativeFrame(.horizontal)
                        case .failure:
                            Color.gray // Stable background on failure
                        @unknown default:
                            Color.gray
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.clear
                }

                // Main Content
                VStack(spacing: 10) {
                    if let weather = viewModel.weather {
                        
                        Label("\(weather.locationName)", systemImage: "mappin.circle")
                            .font(.title)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .padding()
                        
                        List {
                            Label("天気: \(weather.description)", systemImage: "cloud.sun")
                            Label("最高気温: \(weather.tempMax, specifier: "%.1f")℃", systemImage: "thermometer.sun")
                            Label("最低気温: \(weather.tempMin, specifier: "%.1f")℃", systemImage: "thermometer.snowflake")
                            Label("降水確率: \(weather.precipitation)%", systemImage: "cloud.rain")
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden) // デフォルトの背景を非表示
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding()
                        
                    } else {
                        ProgressView("読み込み中...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Weather data will be displayed here.")
                            .padding()
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        Task { await viewModel.switchLocation() }
                    }) {
                        Text("Switch Location")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .navigationTitle("") // Remove default title
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Weather")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 2)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingSettingsSheet = true // Set to true to show the sheet
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.white)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
                .padding()
            }
            .task {
                await viewModel.fetchWeather()
            }
            .sheet(isPresented: $showingSettingsSheet) {
                // Half modal content (empty for now)
                Text("Settings")
                    .font(.largeTitle)
                    .presentationDetents([.medium, .large]) // For half modal behavior
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
