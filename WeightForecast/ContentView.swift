//
//  ContentView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 18) {
                header
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        CurrentWeightCard(
                            title: "Current Weight",
                            subtitle: "-0.3 lbs from previous entry",
                            weight: "180.4",
                            unit: "lbs")
                        
                        WeeklyRateCard(
                            title: "Weekly Rate",
                            subtitle: "Average over last 30 days",
                            rate: "0.9",
                            unit: "lbs", status: "Losing")
                        
                        MilestoneCard(
                            title: "Next Milestone",
                            milestone: "185 lbs",
                            progressLabel: "Progress",
                            percentText: "28%",
                            remainingText: "3.6 lbs to go",
                            progress: 0.28
                        )
                    }
                }
            }
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
