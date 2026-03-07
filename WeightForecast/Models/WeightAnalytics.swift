//
//  WeightAnalytics.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation

/// A service class that calculates analytics from weight data
@Observable
class WeightAnalytics {
    
    /// Calculate the weekly rate of weight change over a specified period
    static func weeklyRate(from entries: [WeightEntry], days: Int = 30) -> Double? {
        let sortedEntries = entries.sorted { $0.date < $1.date }
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let recentEntries = sortedEntries.filter { $0.date >= cutoffDate }
        
        guard recentEntries.count >= 2,
              let firstEntry = recentEntries.first,
              let lastEntry = recentEntries.last else { return nil }
        
        let weightChange = lastEntry.weight - firstEntry.weight
        let daysDifference = Calendar.current.dateComponents([.day], from: firstEntry.date, to: lastEntry.date).day ?? 1
        let weeksElapsed = Double(daysDifference) / 7.0
        
        return weeksElapsed > 0 ? weightChange / weeksElapsed : nil
    }
    
    /// Calculate total weight lost/gained from starting weight
    static func totalWeightChange(from entries: [WeightEntry], startingWeight: Double?) -> Double? {
        guard let currentWeight = entries.sorted(by: { $0.date > $1.date }).first?.weight,
              let starting = startingWeight else { return nil }
        
        return currentWeight - starting
    }
    
    /// Get the current weight (most recent entry)
    static func currentWeight(from entries: [WeightEntry]) -> WeightEntry? {
        return entries.sorted { $0.date > $1.date }.first
    }
    
    /// Calculate change from previous entry
    static func changeFromPrevious(entries: [WeightEntry]) -> Double? {
        let sortedEntries = entries.sorted { $0.date > $1.date }
        guard sortedEntries.count >= 2 else { return nil }
        
        let current = sortedEntries[0]
        let previous = sortedEntries[1]
        return current.weight - previous.weight
    }
    
    /// Get the next milestone to reach
    static func nextMilestone(from milestones: [Milestone], currentWeight: Double) -> Milestone? {
        return milestones
            .filter { !$0.isCompleted }
            .min { abs($0.targetWeight - currentWeight) < abs($1.targetWeight - currentWeight) }
    }
    
    /// Calculate days tracked
    static func daysTracked(from entries: [WeightEntry]) -> Int {
        guard let firstEntry = entries.sorted(by: { $0.date < $1.date }).first else { return 0 }
        
        let days = Calendar.current.dateComponents([.day], from: firstEntry.date, to: Date()).day ?? 0
        return max(0, days)
    }
    
    /// Determine weight trend status
    static func weightTrendStatus(weeklyRate: Double?, goalType: GoalType) -> WeightTrendStatus {
        guard let rate = weeklyRate else { return .unknown }
        
        switch goalType {
        case .weightLoss:
            return rate < -0.1 ? .losing : rate > 0.1 ? .gaining : .maintaining
        case .weightGain:
            return rate > 0.1 ? .gaining : rate < -0.1 ? .losing : .maintaining
        case .maintenance:
            return abs(rate) <= 0.1 ? .maintaining : rate > 0 ? .gaining : .losing
        }
    }
}

enum WeightTrendStatus: String, CaseIterable {
    case losing = "Losing"
    case gaining = "Gaining"
    case maintaining = "Maintaining" 
    case unknown = "Unknown"
    
    var color: String {
        switch self {
        case .losing: return "green"
        case .gaining: return "red"
        case .maintaining: return "blue"
        case .unknown: return "gray"
        }
    }
}