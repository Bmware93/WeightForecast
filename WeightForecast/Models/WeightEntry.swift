//
//  WeightEntry.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftData

@Model
class WeightEntry {
    var weight: Double
    var date: Date
    var notes: String?
    var id: UUID
    
    init(weight: Double, date: Date = Date(), notes: String? = nil) {
        self.weight = weight
        self.date = date
        self.notes = notes
        self.id = UUID()
    }
    
    /// Returns the weight change compared to the previous entry
    func changeFromPrevious(in entries: [WeightEntry]) -> Double? {
        let sortedEntries = entries.sorted { $0.date < $1.date }
        guard let currentIndex = sortedEntries.firstIndex(where: { $0.id == self.id }),
              currentIndex > 0 else { return nil }
        
        let previousEntry = sortedEntries[currentIndex - 1]
        return weight - previousEntry.weight
    }
}