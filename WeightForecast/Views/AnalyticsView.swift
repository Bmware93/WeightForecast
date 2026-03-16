//
//  AnalyticsView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/6/26.
//

import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightEntry.date, order: .forward) private var weightEntries: [WeightEntry]
    @State private var selectedTimeRange: TimeRange = .month
    @State private var showingWeightLog = false
    @State private var showingFullHistory = false
    
    enum TimeRange: String, CaseIterable {
        case week = "1W"
        case month = "1M"
        case threeMonths = "3M"
        case sixMonths = "6M"
        case year = "1Y"
        case all = "All"
        
        var days: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            case .sixMonths: return 180
            case .year: return 365
            case .all: return nil
            }
        }
    }
    
    private var filteredEntries: [WeightEntry] {
        guard let days = selectedTimeRange.days else { return weightEntries }
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return weightEntries.filter { $0.date >= cutoffDate }
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
                        // Time Range Selector
                        timeRangeSelector
                        
                        VStack(spacing: 15) {
                            // Weight Chart
                            weightChartCard
                            
                            // Statistics Cards
                            statisticsSection
                            
                            // Weight History List
                            weightHistoryCard
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
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
        }
        .sheet(isPresented: $showingWeightLog) {
            WeightLogView()
        }
        .sheet(isPresented: $showingFullHistory) {
            WeightHistoryView(
                entries: filteredEntries,
                timeRange: selectedTimeRange.rawValue
            )
        }
    }
    
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button(action: { selectedTimeRange = range }) {
                        Text(range.rawValue)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(selectedTimeRange == range ? .white : .blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(
                                        selectedTimeRange == range ? 
                                        AnyShapeStyle(LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )) : 
                                        AnyShapeStyle(Color.clear)
                                    )
                                    .stroke(
                                        selectedTimeRange == range ? Color.clear : .blue.opacity(0.6),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(
                                color: selectedTimeRange == range ? .blue.opacity(0.3) : .clear,
                                radius: selectedTimeRange == range ? 4 : 0,
                                x: 0,
                                y: 2
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)
        }
    }
    
    private var weightChartCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Weight Trend")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                if filteredEntries.count >= 2 {
                    Chart(filteredEntries) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(.blue)
                    }
                    .frame(height: 200)
                    .chartYScale(domain: .automatic(includesZero: false))
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Not enough data points")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("Add more weight entries to see trends")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var statisticsSection: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Average",
                value: averageWeight,
                unit: "lbs",
                icon: "scale.3d",
                explanation: "The average weight across all entries in the selected time period. This gives you a general sense of your weight level during this timeframe."
            )
            
            StatCard(
                title: "Change",
                value: totalChange,
                unit: "lbs",
                icon: weightChangeIcon,
                explanation: "The total weight change from your first entry to your most recent entry in the selected time period. A negative value indicates weight loss, while a positive value indicates weight gain."
            )
        }
    }
    
    private var weightHistoryCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Recent Entries")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(filteredEntries.count) entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                }
                
                if filteredEntries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "scale.3d")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("No weight entries yet")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("Start logging your weight to see history")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    VStack(spacing: 12) {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(filteredEntries.reversed().prefix(7)), id: \.id) { entry in
                                WeightHistoryRow(entry: entry)
                            }
                        }
                        
                        // Show More button if there are more than 7 entries
                        if filteredEntries.count > 7 {
                            Button(action: { showingFullHistory = true }) {
                                HStack(spacing: 8) {
                                    Text("Show More")
                                        .font(.subheadline.weight(.medium))
                                    
                                    Text("(\(filteredEntries.count - 7) more)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                }
                                .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var averageWeight: String {
        guard !filteredEntries.isEmpty else { return "--" }
        let average = filteredEntries.map(\.weight).reduce(0, +) / Double(filteredEntries.count)
        return String(format: "%.1f", average)
    }
    
    private var totalChange: String {
        guard filteredEntries.count >= 2,
              let first = filteredEntries.first,
              let last = filteredEntries.last else { return "--" }
        let change = last.weight - first.weight
        return String(format: "%+.1f", change)
    }
    
    private var weightChangeIcon: String {
        guard filteredEntries.count >= 2,
              let first = filteredEntries.first,
              let last = filteredEntries.last else { return "minus" }
        let change = last.weight - first.weight
        return change >= 0 ? "arrow.up" : "arrow.down"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let explanation: String?
    
    @State private var showingExplanation = false
    
    init(title: String, value: String, unit: String, icon: String, explanation: String? = nil) {
        self.title = title
        self.value = value
        self.unit = unit
        self.icon = icon
        self.explanation = explanation
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Spacer()
                    
                    if explanation != nil {
                        Button(action: { showingExplanation = true }) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                }
            }
        }
        .alert(title, isPresented: $showingExplanation) {
            Button("OK") { }
        } message: {
            if let explanation = explanation {
                Text(explanation)
            }
        }
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: WeightEntry.self, inMemory: true)
}