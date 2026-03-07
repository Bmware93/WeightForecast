//
//  Milestone.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

@Model
class Milestone {
    var targetWeight: Double
    var title: String
    var isCompleted: Bool
    var completedDate: Date?
    var createdDate: Date
    var id: UUID
    
    init(targetWeight: Double, title: String, isCompleted: Bool = false, completedDate: Date? = nil) {
        self.targetWeight = targetWeight
        self.title = title
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.createdDate = Date()
        self.id = UUID()
    }
    
    /// Calculate progress towards this milestone
    func progress(currentWeight: Double, startingWeight: Double) -> Double {
        let totalDistance = abs(targetWeight - startingWeight)
        let remainingDistance = abs(targetWeight - currentWeight)
        
        guard totalDistance > 0 else { return 1.0 }
        
        let progress = (totalDistance - remainingDistance) / totalDistance
        return max(0, min(1, progress))
    }
    
    /// Calculate remaining weight to reach milestone
    func remainingWeight(from currentWeight: Double) -> Double {
        return abs(targetWeight - currentWeight)
    }
}