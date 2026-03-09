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
    @State private var viewModel: ContentViewModel?
    
    var body: some View {
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
        .onAppear {
            if viewModel == nil {
                viewModel = ContentViewModel(modelContext: modelContext)
                viewModel?.setupInitialUserPreferences()
            }
        }
    }
}

private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
        Text("Overview")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)
        
        Text("Forecast")
            .font(.largeTitle.weight(.semibold))
            .foregroundStyle(
                .linearGradient(
                    colors: [.primary, .primary.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 18)
    .padding(.top, 6)
}

#Preview {
    ContentView()
}
