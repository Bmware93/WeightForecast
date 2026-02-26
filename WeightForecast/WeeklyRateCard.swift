//
//  WeeklyRateCard.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/25/26.
//

import SwiftUI

struct WeeklyRateCard: View {
    var title: String
    var subtitle: String
    var rate: String
    var unit: String
    var status: String
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.12))
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "arrow.down.right")
                            .foregroundStyle(.green)
                            .font(.system(size: 16, weight: .bold))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(rate)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(.primary)
                            Text(unit)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Text(status)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WeeklyRateCard(title: "Weekly Rate", subtitle: "Average over last 30 days", rate: "0.9", unit: "lbs", status: "Losing")
}
