//
//  ProUpsellCardView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/25/26.
//

import SwiftUI

struct ProUpsellCardView: View {
    let title: String
    let bullets: [String]
    let buttonTitle: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.9), Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(bullets, id: \.self) { item in
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("•")
                                .foregroundStyle(.white.opacity(0.9))
                            Text(item)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.95))
                        }
                    }
                }

                Button(action: {}) {
                    Text(buttonTitle)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white)
                        .foregroundStyle(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                //.glassEffect()
                .padding(.top, 6)
               
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

#Preview {
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
