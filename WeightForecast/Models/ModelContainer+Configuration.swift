//
//  ModelContainer+Configuration.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var weightForecastContainer: ModelContainer {
        let schema = Schema([
            WeightEntry.self,
            WeightGoal.self,
            Milestone.self,
            UserPreferences.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic // Enable CloudKit sync
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}