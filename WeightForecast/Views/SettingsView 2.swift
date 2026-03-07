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
                        .linearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) : 
                        .secondary
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
                
                VStack(spacing: 20) {
                    Image(systemName: "target")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Goal Settings")
                        .font(.title2.weight(.semibold))
                    
                    Text("Coming Soon")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Goals")
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

#Preview {
    SettingsView()
        .modelContainer(for: UserPreferences.self, inMemory: true)
}