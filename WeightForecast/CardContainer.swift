//
//  CardContainer.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI

struct CardContainer<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground))
//                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                    .glassEffect()
                    
            )
    }
}

#Preview {
    CardContainer {
        Text("Sample Card Content")
    }
}
