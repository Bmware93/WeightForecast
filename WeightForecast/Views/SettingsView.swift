//
//  SettingsView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/6/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    @State private var showingGoalSheet = false
    @State private var showingAbout = false
    @State private var showingStartingWeightSheet = false
    @State private var showingMilestonesSheet = false
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 18) {
                        // User Profile Section
                        profileSection
                        
                        // Preferences Section
                        preferencesSection
                        
                        // Goals Section
                        goalsSection
                        
                        // Pro Features Section
                        proFeaturesSection
                        
                        // App Information Section
                        appInfoSection
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingGoalSheet) {
            GoalSettingsSheet()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingStartingWeightSheet) {
            StartingWeightSheet()
        }
        .sheet(isPresented: $showingMilestonesSheet) {
            MilestonesSheet()
        }
        .onAppear {
            setupInitialPreferences()
        }
    }
    
    private var profileSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Profile")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Starting Weight",
                        value: startingWeightText,
                        icon: "scalemass",
                        action: { showingStartingWeightSheet = true }
                    )
                    
                    Divider()
                    
                    SettingsRow(
                        title: "Weight Unit",
                        value: preferences?.weightUnit.displayName ?? "lbs",
                        icon: "ruler",
                        action: { toggleWeightUnit() }
                    )
                }
            }
        }
    }
    
    private var preferencesSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Preferences")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ToggleSettingsRow(
                        title: "Trend Smoothing",
                        subtitle: "Show smoothed weight trend line",
                        icon: "waveform.path",
                        isOn: Binding(
                            get: { preferences?.trendSmoothingEnabled ?? false },
                            set: { updateTrendSmoothing($0) }
                        ),
                        isPro: true
                    )
                    
                    Divider()
                    
                    ToggleSettingsRow(
                        title: "Plateau Detection",
                        subtitle: "Get alerts when weight plateaus",
                        icon: "chart.line.flattrend.xyaxis",
                        isOn: Binding(
                            get: { preferences?.plateauDetectionEnabled ?? false },
                            set: { updatePlateauDetection($0) }
                        ),
                        isPro: true
                    )
                }
            }
        }
    }
    
    private var goalsSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "target")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Goals & Milestones")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Weight Goals",
                        value: "Manage",
                        icon: "target",
                        action: { showingGoalSheet = true }
                    )
                    
                    Divider()
                    
                    SettingsRow(
                        title: "Milestones",
                        value: "View All",
                        icon: "flag",
                        action: { showingMilestonesSheet = true }
                    )
                }
            }
        }
    }
    
    private var proFeaturesSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Pro Features")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if preferences?.hasProSubscription ?? false {
                        Text("Active")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .mint],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                }
                
                if preferences?.hasProSubscription ?? false {
                    VStack(alignment: .leading, spacing: 8) {
                        ProFeatureItem(title: "Advanced Analytics", isEnabled: true)
                        ProFeatureItem(title: "Goal Forecasting", isEnabled: true)
                        ProFeatureItem(title: "Plateau Detection", isEnabled: true)
                        ProFeatureItem(title: "Data Export", isEnabled: true)
                    }
                } else {
                    Button(action: { }) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("Upgrade to Pro")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.secondary.opacity(0.1))
                                .stroke(.secondary.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("App Information")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "About WeightForecast",
                        value: "Info",
                        icon: "info.circle",
                        action: { showingAbout = true }
                    )
                    
                    Divider()
                    
                    SettingsRow(
                        title: "Privacy Policy",
                        value: "View",
                        icon: "hand.raised",
                        action: { }
                    )
                    
                    Divider()
                    
                    SettingsRow(
                        title: "App Version",
                        value: "1.0.0",
                        icon: "app.badge",
                        action: nil
                    )
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var startingWeightText: String {
        if let startingWeight = preferences?.startingWeight {
            let unit = preferences?.weightUnit.displayName ?? "lbs"
            return String(format: "%.1f %@", startingWeight, unit)
        } else {
            return "Not set"
        }
    }
    
    // MARK: - Actions
    
    private func setupInitialPreferences() {
        guard userPreferences.isEmpty else { return }
        
        let newPreferences = UserPreferences()
        modelContext.insert(newPreferences)
        try? modelContext.save()
    }
    
    private func toggleWeightUnit() {
        guard let preferences = preferences else { return }
        
        preferences.weightUnit = preferences.weightUnit == .pounds ? .kilograms : .pounds
        preferences.lastUpdated = Date()
        
        try? modelContext.save()
    }
    
    private func updateTrendSmoothing(_ enabled: Bool) {
        guard let preferences = preferences else { return }
        
        if preferences.hasProSubscription {
            preferences.trendSmoothingEnabled = enabled
            preferences.lastUpdated = Date()
            try? modelContext.save()
        }
    }
    
    private func updatePlateauDetection(_ enabled: Bool) {
        guard let preferences = preferences else { return }
        
        if preferences.hasProSubscription {
            preferences.plateauDetectionEnabled = enabled
            preferences.lastUpdated = Date()
            try? modelContext.save()
        }
    }
}

struct SettingsRow: View {
    let title: String
    let value: String
    let icon: String
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.secondary.opacity(0.1))
                    )
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

struct ToggleSettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    let isPro: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                    
                    if isPro {
                        Text("PRO")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [.yellow, .orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                    
                    Spacer()
                }
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct ProFeatureItem: View {
    let title: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "circle")
                .font(.body)
                .foregroundStyle(
                    isEnabled ? 
                        AnyShapeStyle(LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )) : 
                        AnyShapeStyle(Color.secondary)
                )
            
            Text(title)
                .font(.body.weight(.medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct GoalSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [WeightGoal]
    @Query private var userPreferences: [UserPreferences]
    
    @State private var showingAddGoal = false
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    private var activeGoal: WeightGoal? {
        goals.first { $0.isActive }
    }
    
    private var completedGoals: [WeightGoal] {
        goals.filter { !$0.isActive }.sorted { $0.createdDate > $1.createdDate }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let activeGoal = activeGoal {
                            currentGoalView(activeGoal)
                        } else {
                            emptyStateView
                        }
                        
                        if !completedGoals.isEmpty {
                            completedGoalsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if activeGoal == nil {
                        Button(action: { showingAddGoal = true }) {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalSheet()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundStyle(
                    .linearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("No Active Goal")
                    .font(.title2.weight(.semibold))
                
                Text("Set a weight goal to start tracking your progress towards your target")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddGoal = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Set Your Goal")
                }
                .font(.body.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 60)
    }
    
    private func currentGoalView(_ goal: WeightGoal) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Current Goal")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.secondary)
                
                Text(goal.goalType.displayName)
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
            }
            
            GoalCard(goal: goal, preferences: preferences, isCurrentGoal: true)
            
            Button(action: { showingAddGoal = true }) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Change Goal")
                }
                .font(.body.weight(.medium))
                .foregroundColor(.accentColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.secondary.opacity(0.1))
                        .stroke(.secondary.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Completed Goals")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(completedGoals.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.secondary)
                    )
            }
            
            VStack(spacing: 12) {
                ForEach(completedGoals.prefix(3), id: \.id) { goal in
                    CompletedGoalRow(goal: goal, preferences: preferences)
                }
                
                if completedGoals.count > 3 {
                    Button(action: {}) {
                        HStack {
                            Text("View All (\(completedGoals.count))")
                                .font(.body.weight(.medium))
                                .foregroundColor(.accentColor)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct GoalCard: View {
    let goal: WeightGoal
    let preferences: UserPreferences?
    let isCurrentGoal: Bool
    @Environment(\.modelContext) private var modelContext
    
    init(goal: WeightGoal, preferences: UserPreferences?, isCurrentGoal: Bool = false) {
        self.goal = goal
        self.preferences = preferences
        self.isCurrentGoal = isCurrentGoal
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.goalType.displayName)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        if let targetDate = goal.targetDate {
                            Text("Target: \(targetDate, format: .dateTime.month().day().year())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    goalTypeIcon
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Target Weight")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                        
                        Text(formattedWeight)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Menu {
                        if isCurrentGoal {
                            Button(action: { toggleGoalStatus() }) {
                                Label("Mark as Complete", systemImage: "checkmark.circle")
                            }
                        }
                        
                        Button(role: .destructive, action: { deleteGoal() }) {
                            Label("Delete Goal", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var goalTypeIcon: some View {
        Image(systemName: iconForGoalType)
            .font(.title2)
            .foregroundStyle(
                .linearGradient(
                    colors: colorsForGoalType,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var iconForGoalType: String {
        switch goal.goalType {
        case .weightLoss: return "arrow.down.circle.fill"
        case .weightGain: return "arrow.up.circle.fill"
        case .maintenance: return "equal.circle.fill"
        }
    }
    
    private var colorsForGoalType: [Color] {
        switch goal.goalType {
        case .weightLoss: return [.red, .orange]
        case .weightGain: return [.green, .mint]
        case .maintenance: return [.blue, .cyan]
        }
    }
    
    private var formattedWeight: String {
        let unit = preferences?.weightUnit.displayName ?? "lbs"
        return String(format: "%.1f %@", goal.targetWeight, unit)
    }
    
    private func toggleGoalStatus() {
        goal.isActive.toggle()
        try? modelContext.save()
    }
    
    private func deleteGoal() {
        modelContext.delete(goal)
        try? modelContext.save()
    }
}

struct CompletedGoalRow: View {
    let goal: WeightGoal
    let preferences: UserPreferences?
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.body)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(goal.goalType.displayName)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                
                Text("Target: \(formattedWeight)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let targetDate = goal.targetDate {
                Text(targetDate, format: .dateTime.month().day().year())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var formattedWeight: String {
        let unit = preferences?.weightUnit.displayName ?? "lbs"
        return String(format: "%.1f %@", goal.targetWeight, unit)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 16) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("WeightForecast")
                                .font(.title.weight(.semibold))
                            
                            Text("Version 1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        
                        CardContainer {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("About")
                                    .font(.headline.weight(.semibold))
                                
                                Text("WeightForecast helps you track your weight journey with intelligent analytics and forecasting. Set goals, track progress, and understand your trends with our advanced analytics.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        CardContainer {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Features")
                                    .font(.headline.weight(.semibold))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    BulletPoint(text: "Smart weight tracking with trend analysis")
                                    BulletPoint(text: "Goal setting and milestone tracking")
                                    BulletPoint(text: "Advanced analytics and forecasting")
                                    BulletPoint(text: "Secure local storage with CloudKit sync")
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.body)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct AddGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    @Query private var goals: [WeightGoal]
    
    @State private var targetWeight: Double = 0.0
    @State private var selectedGoalType: GoalType = .weightLoss
    @State private var hasTargetDate = false
    @State private var targetDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 days from now
    @State private var weightText = ""
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    private var hasActiveGoal: Bool {
        goals.contains { $0.isActive }
    }
    
    private var navigationTitle: String {
        hasActiveGoal ? "Change Goal" : "Set Goal"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        goalTypeSection
                        targetWeightSection
                        targetDateSection
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var goalTypeSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("Goal Type")
                    .font(.headline.weight(.semibold))
                
                VStack(spacing: 12) {
                    ForEach(GoalType.allCases, id: \.self) { goalType in
                        GoalTypeRow(
                            goalType: goalType,
                            isSelected: selectedGoalType == goalType
                        ) {
                            selectedGoalType = goalType
                        }
                    }
                }
            }
        }
    }
    
    private var targetWeightSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("Target Weight")
                    .font(.headline.weight(.semibold))
                
                HStack {
                    TextField("Enter weight", text: $weightText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: weightText) { _, newValue in
                            if let weight = Double(newValue) {
                                targetWeight = weight
                            }
                        }
                    
                    Text(preferences?.weightUnit.displayName ?? "lbs")
                        .font(.body.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
            }
        }
    }
    
    private var targetDateSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Target Date")
                        .font(.headline.weight(.semibold))
                    
                    Spacer()
                    
                    Toggle("", isOn: $hasTargetDate)
                        .labelsHidden()
                }
                
                if hasTargetDate {
                    DatePicker(
                        "Target Date",
                        selection: $targetDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveGoal) {
            HStack {
                Image(systemName: "target")
                Text(hasActiveGoal ? "Update Goal" : "Save Goal")
            }
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(targetWeight <= 0)
        .opacity(targetWeight <= 0 ? 0.6 : 1.0)
    }
    
    private func saveGoal() {
        // Deactivate any existing active goals
        for existingGoal in goals where existingGoal.isActive {
            existingGoal.isActive = false
        }
        
        let goal = WeightGoal(
            targetWeight: targetWeight,
            targetDate: hasTargetDate ? targetDate : nil,
            goalType: selectedGoalType
        )
        
        modelContext.insert(goal)
        try? modelContext.save()
        dismiss()
    }
}

struct GoalTypeRow: View {
    let goalType: GoalType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconForGoalType)
                    .font(.title3)
                    .foregroundStyle(
                        .linearGradient(
                            colors: colorsForGoalType,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(goalType.displayName)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(descriptionForGoalType)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
                    .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var iconForGoalType: String {
        switch goalType {
        case .weightLoss: return "arrow.down.circle"
        case .weightGain: return "arrow.up.circle"
        case .maintenance: return "equal.circle"
        }
    }
    
    private var colorsForGoalType: [Color] {
        switch goalType {
        case .weightLoss: return [.red, .orange]
        case .weightGain: return [.green, .mint]
        case .maintenance: return [.blue, .cyan]
        }
    }
    
    private var descriptionForGoalType: String {
        switch goalType {
        case .weightLoss: return "Lose weight gradually"
        case .weightGain: return "Gain weight healthily"
        case .maintenance: return "Maintain current weight"
        }
    }
}

struct StartingWeightSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    
    @State private var weightText = ""
    @State private var weight: Double = 0.0
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                VStack(spacing: 32) {
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(spacing: 8) {
                        Text("Set Starting Weight")
                            .font(.title2.weight(.semibold))
                        
                        Text("Enter your starting weight to track your progress")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    CardContainer {
                        VStack(spacing: 16) {
                            HStack {
                                TextField("Enter weight", text: $weightText)
                                    .keyboardType(.decimalPad)
                                    .font(.title3.weight(.medium))
                                    .textFieldStyle(.plain)
                                    .multilineTextAlignment(.center)
                                    .onChange(of: weightText) { _, newValue in
                                        if let newWeight = Double(newValue) {
                                            weight = newWeight
                                        }
                                    }
                                
                                Text(preferences?.weightUnit.displayName ?? "lbs")
                                    .font(.title3.weight(.medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Button(action: saveStartingWeight) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Save Starting Weight")
                        }
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(weight <= 0)
                    .opacity(weight <= 0 ? 0.6 : 1.0)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Starting Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let startingWeight = preferences?.startingWeight {
                weight = startingWeight
                weightText = String(format: "%.1f", startingWeight)
            }
        }
    }
    
    private func saveStartingWeight() {
        guard let preferences = preferences else { return }
        
        preferences.startingWeight = weight
        preferences.lastUpdated = Date()
        
        try? modelContext.save()
        dismiss()
    }
}

struct MilestonesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var milestones: [Milestone]
    @Query private var userPreferences: [UserPreferences]
    @Query private var weightEntries: [WeightEntry]
    
    @State private var showingAddMilestone = false
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    private var currentWeight: Double? {
        weightEntries.sorted { $0.date > $1.date }.first?.weight
    }
    
    private var startingWeight: Double? {
        preferences?.startingWeight
    }
    
    private var activeMilestones: [Milestone] {
        milestones.filter { !$0.isCompleted }.sorted { milestone1, milestone2 in
            guard let current = currentWeight, let starting = startingWeight else { return false }
            return milestone1.remainingWeight(from: current) < milestone2.remainingWeight(from: current)
        }
    }
    
    private var completedMilestones: [Milestone] {
        milestones.filter { $0.isCompleted }.sorted { ($0.completedDate ?? $0.createdDate) > ($1.completedDate ?? $1.createdDate) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if activeMilestones.isEmpty && completedMilestones.isEmpty {
                            emptyStateView
                        } else {
                            if !activeMilestones.isEmpty {
                                activeMilestonesSection
                            }
                            
                            if !completedMilestones.isEmpty {
                                completedMilestonesSection
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Milestones")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMilestone = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddMilestone) {
            AddMilestoneSheet()
        }
        .onAppear {
            checkMilestoneCompletion()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "flag.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    .linearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("No Milestones Set")
                    .font(.title2.weight(.semibold))
                
                Text("Set milestones to celebrate your progress and stay motivated on your journey")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddMilestone = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Your First Milestone")
                }
                .font(.body.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 60)
    }
    
    private var activeMilestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Milestones")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(activeMilestones.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            
            VStack(spacing: 16) {
                ForEach(activeMilestones, id: \.id) { milestone in
                    MilestoneDetailCard(
                        milestone: milestone,
                        preferences: preferences,
                        currentWeight: currentWeight,
                        startingWeight: startingWeight,
                        isCompleted: false
                    )
                }
            }
        }
    }
    
    private var completedMilestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Completed")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(completedMilestones.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.green, .mint],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            
            VStack(spacing: 12) {
                ForEach(completedMilestones, id: \.id) { milestone in
                    MilestoneDetailCard(
                        milestone: milestone,
                        preferences: preferences,
                        currentWeight: currentWeight,
                        startingWeight: startingWeight,
                        isCompleted: true
                    )
                }
            }
        }
    }
    
    private func checkMilestoneCompletion() {
        guard let current = currentWeight else { return }
        
        var hasChanges = false
        
        for milestone in activeMilestones {
            let remainingWeight = milestone.remainingWeight(from: current)
            
            // Check if milestone is reached (within 0.5 lbs/kg tolerance)
            if remainingWeight <= 0.5 {
                milestone.isCompleted = true
                milestone.completedDate = Date()
                hasChanges = true
            }
        }
        
        if hasChanges {
            try? modelContext.save()
        }
    }
}

struct MilestoneDetailCard: View {
    let milestone: Milestone
    let preferences: UserPreferences?
    let currentWeight: Double?
    let startingWeight: Double?
    let isCompleted: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(milestone.title)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        if isCompleted {
                            if let completedDate = milestone.completedDate {
                                Text("Completed \(completedDate, format: .dateTime.month().day().year())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text("Target: \(formattedWeight)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "flag.fill")
                            .font(.title2)
                            .foregroundStyle(
                                .linearGradient(
                                    colors: isCompleted ? [.green, .mint] : [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        if !isCompleted && currentWeight != nil {
                            Text(remainingText)
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if !isCompleted {
                    progressSection
                }
                
                HStack {
                    Spacer()
                    
                    Menu {
                        if !isCompleted {
                            Button(action: { markAsCompleted() }) {
                                Label("Mark as Completed", systemImage: "checkmark.circle")
                            }
                        } else {
                            Button(action: { markAsIncomplete() }) {
                                Label("Mark as Incomplete", systemImage: "arrow.clockwise")
                            }
                        }
                        
                        Button(role: .destructive, action: { deleteMilestone() }) {
                            Label("Delete Milestone", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(progressPercentage * 100))%")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
            
            ProgressView(value: progressPercentage)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    private var formattedWeight: String {
        let unit = preferences?.weightUnit.displayName ?? "lbs"
        return String(format: "%.1f %@", milestone.targetWeight, unit)
    }
    
    private var remainingText: String {
        guard let current = currentWeight else { return "" }
        let remaining = milestone.remainingWeight(from: current)
        let unit = preferences?.weightUnit.displayName ?? "lbs"
        return String(format: "%.1f %@ to go", remaining, unit)
    }
    
    private var progressPercentage: Double {
        guard let current = currentWeight, let starting = startingWeight else { return 0 }
        return milestone.progress(currentWeight: current, startingWeight: starting)
    }
    
    private func markAsCompleted() {
        milestone.isCompleted = true
        milestone.completedDate = Date()
        try? modelContext.save()
    }
    
    private func markAsIncomplete() {
        milestone.isCompleted = false
        milestone.completedDate = nil
        try? modelContext.save()
    }
    
    private func deleteMilestone() {
        modelContext.delete(milestone)
        try? modelContext.save()
    }
}

struct AddMilestoneSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var userPreferences: [UserPreferences]
    
    @State private var title = ""
    @State private var targetWeight: Double = 0.0
    @State private var weightText = ""
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        targetWeightSection
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle("New Milestone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var titleSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("Milestone Title")
                    .font(.headline.weight(.semibold))
                
                TextField("Enter a motivating title", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.next)
                
                Text("Examples: \"First 10 lbs lost\", \"Halfway to goal\", \"Under 200 lbs\"")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var targetWeightSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("Target Weight")
                    .font(.headline.weight(.semibold))
                
                HStack {
                    TextField("Enter weight", text: $weightText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: weightText) { _, newValue in
                            if let weight = Double(newValue) {
                                targetWeight = weight
                            }
                        }
                    
                    Text(preferences?.weightUnit.displayName ?? "lbs")
                        .font(.body.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveMilestone) {
            HStack {
                Image(systemName: "flag.fill")
                Text("Create Milestone")
            }
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || targetWeight <= 0)
        .opacity((title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || targetWeight <= 0) ? 0.6 : 1.0)
    }
    
    private func saveMilestone() {
        let milestone = Milestone(
            targetWeight: targetWeight,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        modelContext.insert(milestone)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [UserPreferences.self, WeightGoal.self, Milestone.self, WeightEntry.self], inMemory: true)
}