//
//  ContentView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightEntry.date, order: .reverse) private var weightEntries: [WeightEntry]
    @State private var viewModel: ContentViewModel?
    @State private var showingWeightLog = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 18) {
                header
                
                if let viewModel = viewModel {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            CurrentWeightCard(
                                title: "Current Weight",
                                subtitle: viewModel.currentWeightData.change,
                                weight: viewModel.currentWeightData.weight,
                                unit: viewModel.currentWeightData.unit)
                            
                            WeeklyRateCard(
                                title: "Weekly Rate",
                                subtitle: "Average over last 30 days",
                                rate: viewModel.weeklyRateData.rate,
                                unit: viewModel.weeklyRateData.unit,
                                status: viewModel.weeklyRateData.status)
                            
                            MilestoneCard(
                                title: "Next Milestone",
                                milestone: viewModel.nextMilestoneData.milestone,
                                progressLabel: "Progress",
                                percentText: viewModel.nextMilestoneData.progressPercent,
                                remainingText: viewModel.nextMilestoneData.remaining,
                                progress: viewModel.nextMilestoneData.progress)
                              
                            ProgressStatsView(
                                leftTitle: "Total Lost",
                                leftValue: viewModel.progressStatsData.totalLost,
                                rightTitle: "Days Tracked",
                                rightValue: viewModel.progressStatsData.daysTracked
                            )
                            
                            Spacer()
                            
                            if viewModel.shouldShowProUpsell {
                                ProUpsellCardView(
                                    title: "Unlock Pro Features",
                                    bullets: [
                                        "Trend weight smoothing",
                                        "Goal date forecasting",
                                        "Plateau detection",
                                        "Advanced analytics"
                                    ],
                                    buttonTitle: "Upgrade to Pro"
                                )
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 16)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            // Floating Add Button
            Button(action: { showingWeightLog = true }) {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(Color.blue))
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 18)
            .padding(.bottom, 16)
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ContentViewModel(modelContext: modelContext)
                viewModel?.setupInitialUserPreferences()
            }
            // Update weight entries whenever they change
            viewModel?.updateWeightEntries(weightEntries)
        }
        .onChange(of: weightEntries) { _, newEntries in
            // Automatically update when weight entries change
            viewModel?.updateWeightEntries(newEntries)
        }
        .sheet(isPresented: $showingWeightLog) {
            WeightLogView()
        }
    }
}

private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
        Text("Overview")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        
        Text("Forecast")
            .font(.largeTitle.weight(.regular))
            .foregroundStyle(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 18)
    .padding(.top, 6)
}

#Preview {
    ContentView()
}
