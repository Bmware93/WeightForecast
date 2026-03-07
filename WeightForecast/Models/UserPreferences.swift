//
//  UserPreferences.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    var weightUnit: WeightUnit
    var startingWeight: Double?
    var hasProSubscription: Bool
    var onboardingCompleted: Bool
    var trendSmoothingEnabled: Bool
    var plateauDetectionEnabled: Bool
    var lastUpdated: Date
    
    init(
        weightUnit: WeightUnit = .pounds,
        startingWeight: Double? = nil,
        hasProSubscription: Bool = false,
        onboardingCompleted: Bool = false,
        trendSmoothingEnabled: Bool = false,
        plateauDetectionEnabled: Bool = false
    ) {
        self.weightUnit = weightUnit
        self.startingWeight = startingWeight
        self.hasProSubscription = hasProSubscription
        self.onboardingCompleted = onboardingCompleted
        self.trendSmoothingEnabled = trendSmoothingEnabled
        self.plateauDetectionEnabled = plateauDetectionEnabled
        self.lastUpdated = Date()
    }
}

enum WeightUnit: String, CaseIterable, Codable {
    case pounds = "lbs"
    case kilograms = "kg"
    
    var displayName: String {
        switch self {
        case .pounds: return "lbs"
        case .kilograms: return "kg"
        }
    }
    
    var conversionToKg: Double {
        switch self {
        case .pounds: return 0.453592
        case .kilograms: return 1.0
        }
    }
}