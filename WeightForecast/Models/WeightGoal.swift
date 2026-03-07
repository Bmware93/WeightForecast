//
//  WeightGoal.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

@Model
class WeightGoal {
    var targetWeight: Double
    var targetDate: Date?
    var goalType: GoalType
    var isActive: Bool
    var createdDate: Date
    var id: UUID
    
    init(targetWeight: Double, targetDate: Date? = nil, goalType: GoalType, isActive: Bool = true) {
        self.targetWeight = targetWeight
        self.targetDate = targetDate
        self.goalType = goalType
        self.isActive = isActive
        self.createdDate = Date()
        self.id = UUID()
    }
}

enum GoalType: String, CaseIterable, Codable {
    case weightLoss = "weight_loss"
    case weightGain = "weight_gain"
    case maintenance = "maintenance"
    
    var displayName: String {
        switch self {
        case .weightLoss: return "Weight Loss"
        case .weightGain: return "Weight Gain"  
        case .maintenance: return "Weight Maintenance"
        }
    }
}