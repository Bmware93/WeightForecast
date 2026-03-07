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
    
    private var preferences: UserPreferences? {
        userPreferences.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
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
        .onAppear {
            setupInitialPreferences()
        }
    }
    
    private var profileSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("Profile")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Starting Weight",
                        value: startingWeightText,
                        icon: "scalemass",
                        action: { }
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
                Text("Preferences")
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
                Text("Goals & Milestones")
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
                        action: { }
                    )
                }
            }
        }
    }
    
    private var proFeaturesSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Pro Features")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if preferences?.hasProSubscription ?? false {
                        Text("Active")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.green)
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
                                .foregroundColor(.yellow)
                            Text("Upgrade to Pro")
                                .font(.body.weight(.medium))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                Text("App Information")
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
                
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
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    if isPro {
                        Text("PRO")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .stroke(Color.yellow, lineWidth: 1)
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
                .foregroundColor(isEnabled ? .green : .secondary)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct GoalSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Goal Settings")
                    .font(.title2)
                
                Text("Coming Soon")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 16) {
                        Image(systemName: "scalemass.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("WeightForecast")
                            .font(.title.weight(.semibold))
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.headline)
                        
                        Text("WeightForecast helps you track your weight journey with intelligent analytics and forecasting. Set goals, track progress, and understand your trends with our advanced analytics.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Features")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BulletPoint(text: "Smart weight tracking with trend analysis")
                            BulletPoint(text: "Goal setting and milestone tracking")
                            BulletPoint(text: "Advanced analytics and forecasting")
                            BulletPoint(text: "Secure local storage with CloudKit sync")
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
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
                .foregroundColor(.blue)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: UserPreferences.self, inMemory: true)
}