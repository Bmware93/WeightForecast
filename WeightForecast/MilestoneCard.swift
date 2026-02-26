//
//  MilestoneCard.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/25/26.
//

import SwiftUI

struct MilestoneCard: View {
        let title: String
        let milestone: String
        let progressLabel: String
        let percentText: String
        let remainingText: String
        let progress: CGFloat

        var body: some View {
            CardContainer {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(milestone)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "trophy")
                            .foregroundStyle(.orange)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 2)
                    }

                    HStack {
                        Text(progressLabel)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(percentText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    ProgressPillView(progress: progress)

                    Text(remainingText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
}

#Preview {
    MilestoneCard(
        title: "Next Milestone",
        milestone: "185 lbs",
        progressLabel: "Progress",
        percentText: "28%",
        remainingText: "3.6 lbs to go",
        progress: 0.28
    )
}
