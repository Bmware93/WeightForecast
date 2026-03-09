//
//  ProgressStatsView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/25/26.
//

import SwiftUI

struct ProgressStatsView: View {
    let leftTitle: String
    let leftValue: String
    let rightTitle: String
    let rightValue: String

    var body: some View {
        CardContainer {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(leftTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(leftValue)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    Text(rightTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(rightValue)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                }

                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    ProgressStatsView(
        leftTitle: "Total Lost",
        leftValue: "6.2 lbs",
        rightTitle: "Days Tracked",
        rightValue: "45"
    )
}
