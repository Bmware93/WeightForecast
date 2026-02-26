//
//  ProgressPillView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/25/26.
//

import SwiftUI

struct ProgressPillView: View {
    let progress: CGFloat // 0...1

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(height: 10)

                Capsule()
                    .fill(Color.green)
                    .frame(width: max(0, min(1, progress)) * geo.size.width, height: 10)
            }
        }
        .frame(height: 10)
    }
}

#Preview {
    ProgressPillView(progress: 0.50)
}
