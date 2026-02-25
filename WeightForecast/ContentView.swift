//
//  ContentView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Group {
                    Text("Current Weight")
                    Text("Average over the last 30 days")
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .topLeading)
            }
            
        }
        .padding()
        .aspectRatio(1.25, contentMode: .fit)
        .frame(width: 355, height: 145)
        .background(Color(.systemGray3))
        .cornerRadius(16)
        .padding()
    }
}

#Preview {
    ContentView()
}
