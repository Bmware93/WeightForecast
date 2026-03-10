//
//  MainTabView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/6/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var showingWeightLog = false
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Overview")
                }
                .overlay(alignment: .bottomTrailing) {
                    // Modern Floating Add Button
                    Button(action: { showingWeightLog = true }) {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle().fill(
                                    LinearGradient(
                                        colors: [.blue, .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    .padding(.trailing, 18)
                    .padding(.bottom, 16)
                }
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .sheet(isPresented: $showingWeightLog) {
            WeightLogView()
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(ModelContainer.weightForecastContainer)
}