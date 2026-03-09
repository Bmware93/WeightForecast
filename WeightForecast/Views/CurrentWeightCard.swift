//
//  CurrentWeightCard.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI

struct CurrentWeightCard: View {
    let title: String
    let subtitle: String
    let weight: String
    let unit: String
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(weight)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(unit)
                        .font(.title3.weight(.regular))
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.green)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }
            }
        }
    }
}

#Preview {
    CurrentWeightCard(title: "Current Weight", subtitle: "-0.3 lbs from previous entry", weight: "180.6", unit: "lbs")
}
