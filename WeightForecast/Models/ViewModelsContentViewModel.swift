//
//  ContentViewModel.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

@Observable
class ContentViewModel {
    private let modelContext: ModelContext
    
    var weightEntries: [WeightEntry] = []
    var milestones: [Milestone] = []
    var userPreferences: UserPreferences?
    var currentGoal: WeightGoal?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadData()
    }
    
    private func loadData() {
        // Weight entries are now passed in via updateWeightEntries()
        // No need to fetch them here
        
        // Fetch milestones
        let milestoneDescriptor = FetchDescriptor<Milestone>()
        milestones = (try? modelContext.fetch(milestoneDescriptor)) ?? []
        
        // Fetch user preferences
        let preferencesDescriptor = FetchDescriptor<UserPreferences>()
        userPreferences = try? modelContext.fetch(preferencesDescriptor).first
        
        // Fetch current goal
        let goalDescriptor = FetchDescriptor<WeightGoal>(
            predicate: #Predicate { $0.isActive == true }
        )
        currentGoal = try? modelContext.fetch(goalDescriptor).first
    }
    
    // MARK: - Computed Properties for UI
    
    var currentWeightData: (weight: String, unit: String, change: String) {
        guard let currentEntry = WeightAnalytics.currentWeight(from: weightEntries),
              let preferences = userPreferences else {
            return ("--", "lbs", "No data")
        }
        
        let weightString = String(format: "%.1f", currentEntry.weight)
        let changeValue = WeightAnalytics.changeFromPrevious(entries: weightEntries) ?? 0
        let changeString = String(format: "%+.1f %@ from previous entry", 
                                changeValue, preferences.weightUnit.displayName)
        
        return (weightString, preferences.weightUnit.displayName, changeString)
    }
    
    var weeklyRateData: (rate: String, unit: String, status: String) {
        guard let weeklyRate = WeightAnalytics.weeklyRate(from: weightEntries),
              let preferences = userPreferences,
              let goal = currentGoal else {
            return ("--", "lbs per week", "Unknown")
        }
        
        let rateString = String(format: "%.1f", abs(weeklyRate))
        let status = WeightAnalytics.weightTrendStatus(weeklyRate: weeklyRate, goalType: goal.goalType)
        
        return (rateString, "\(preferences.weightUnit.displayName) per week", status.rawValue)
    }
    
    var nextMilestoneData: (milestone: String, progress: Double, remaining: String, progressPercent: String) {
        guard let currentEntry = WeightAnalytics.currentWeight(from: weightEntries),
              let nextMilestone = WeightAnalytics.nextMilestone(from: milestones, currentWeight: currentEntry.weight),
              let startingWeight = userPreferences?.startingWeight,
              let preferences = userPreferences else {
            return ("No milestone set", 0, "--", "0%")
        }
        
        let milestoneString = String(format: "%.0f %@", nextMilestone.targetWeight, preferences.weightUnit.displayName)
        let progress = nextMilestone.progress(currentWeight: currentEntry.weight, startingWeight: startingWeight)
        let remaining = nextMilestone.remainingWeight(from: currentEntry.weight)
        let remainingString = String(format: "%.1f %@ to go", remaining, preferences.weightUnit.displayName)
        let progressPercent = String(format: "%.0f%%", progress * 100)
        
        return (milestoneString, progress, remainingString, progressPercent)
    }
    
    var progressStatsData: (totalLost: String, daysTracked: String) {
        guard let preferences = userPreferences else {
            return ("--", "0")
        }
        
        let totalChange = WeightAnalytics.totalWeightChange(from: weightEntries, 
                                                          startingWeight: preferences.startingWeight) ?? 0
        let totalString = String(format: "%.1f %@", abs(totalChange), preferences.weightUnit.displayName)
        let daysTracked = WeightAnalytics.daysTracked(from: weightEntries)
        
        return (totalString, "\(daysTracked)")
    }
    
    var shouldShowProUpsell: Bool {
        return userPreferences?.hasProSubscription ?? false
    }
    
    // MARK: - Actions
    
    func refreshData() {
        loadData()
    }
    
    func updateWeightEntries(_ entries: [WeightEntry]) {
        self.weightEntries = entries
    }
    
    func addWeightEntry(_ weight: Double, date: Date = Date(), notes: String? = nil) {
        let entry = WeightEntry(weight: weight, date: date, notes: notes)
        modelContext.insert(entry)
        try? modelContext.save()
        loadData() // Refresh data
    }
    
    func addMilestone(targetWeight: Double, title: String) {
        let milestone = Milestone(targetWeight: targetWeight, title: title)
        modelContext.insert(milestone)
        try? modelContext.save()
        loadData()
    }
    
    func setupInitialUserPreferences() {
        guard userPreferences == nil else { return }
        
        let preferences = UserPreferences()
        modelContext.insert(preferences)
        try? modelContext.save()
        loadData()
    }
}
