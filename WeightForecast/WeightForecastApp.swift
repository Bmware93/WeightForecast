//
//  WeightForecastApp.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI
import SwiftData

@main
struct WeightForecastApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(ModelContainer.weightForecastContainer)
    }
}
