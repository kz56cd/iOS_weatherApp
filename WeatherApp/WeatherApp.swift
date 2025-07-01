//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Masakazu Sano on 2025/07/01.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environmentObject(appSettings)
        }
    }
}
