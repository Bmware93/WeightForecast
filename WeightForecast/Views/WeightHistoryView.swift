//
//  WeightHistoryView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/16/26.
//

import SwiftUI
import SwiftData

struct WeightHistoryView: View {
    let entries: [WeightEntry]
    let timeRange: String
    @Environment(\.dismiss) private var dismiss
    
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
                    VStack(spacing: 16) {
                        // Summary Header
                        summaryHeader
                        
                        // All Entries
                        entriesList
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Weight History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var summaryHeader: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Complete History")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(timeRange)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                }
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Entries")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(entries.count)")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.primary)
                    }
                    
                    if entries.count >= 2 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Date Range")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(dateRangeText)
                                .font(.caption.weight(.medium))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private var entriesList: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("All Entries")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                LazyVStack(spacing: 12) {
                    ForEach(Array(entries.reversed().enumerated()), id: \.element.id) { index, entry in
                        VStack {
                            WeightHistoryRow(entry: entry, showDivider: false)
                            
                            if index < entries.count - 1 {
                                Divider()
                                    .padding(.horizontal, -18)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var dateRangeText: String {
        guard entries.count >= 2,
              let earliest = entries.first?.date,
              let latest = entries.last?.date else {
            return "N/A"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return "\(formatter.string(from: earliest)) - \(formatter.string(from: latest))"
    }
}

// Enhanced WeightHistoryRow for better display in full list
struct WeightHistoryRow: View {
    let entry: WeightEntry
    var showDivider: Bool = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(entry.weight, specifier: "%.1f") lbs")
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if let notes = entry.notes, !notes.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "note.text")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("Note")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(entry.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            // Could add detail view navigation here if needed
        }
    }
}

#Preview {
    WeightHistoryView(
        entries: [],
        timeRange: "Last 30 Days"
    )
}