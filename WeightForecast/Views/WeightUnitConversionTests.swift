//
//  WeightUnitConversionTests.swift
//  WeightForecast
//
//  Created by Unit Conversion Fix on 3/9/26.
//

#if canImport(Testing)
import Testing
@testable import WeightForecast

@Suite("Weight Unit Conversion Tests")
struct WeightUnitConversionTests {
    
    @Test("Converting 150 lbs to kg should give approximately 68.04 kg")
    @MainActor
    func testPoundsToKilograms() throws {
        let weightInPounds: Double = 150.0
        let expectedWeightInKg: Double = 68.04 // 150 * 0.453592
        
        // Simulate the conversion logic
        let actualWeightInKg = weightInPounds * WeightUnit.pounds.conversionToKg
        
        #expect(abs(actualWeightInKg - expectedWeightInKg) < 0.01, 
                "150 lbs should convert to approximately 68.04 kg")
    }
    
    @Test("Converting 70 kg to lbs should give approximately 154.32 lbs")
    @MainActor
    func testKilogramsToPounds() throws {
        let weightInKg: Double = 70.0
        let expectedWeightInLbs: Double = 154.32 // 70 / 0.453592
        
        // Simulate the conversion logic
        let actualWeightInLbs = weightInKg / WeightUnit.pounds.conversionToKg
        
        #expect(abs(actualWeightInLbs - expectedWeightInLbs) < 0.01,
                "70 kg should convert to approximately 154.32 lbs")
    }
    
    @Test("Round trip conversion should maintain accuracy")
    @MainActor
    func testRoundTripConversion() throws {
        let originalWeight: Double = 180.0
        
        // Convert lbs -> kg -> lbs
        let weightInKg = originalWeight * WeightUnit.pounds.conversionToKg
        let backToLbs = weightInKg / WeightUnit.pounds.conversionToKg
        
        #expect(abs(backToLbs - originalWeight) < 0.001,
                "Round trip conversion should maintain accuracy")
    }
    
    @Test("Conversion factor accuracy")
    @MainActor
    func testConversionFactorAccuracy() throws {
        let expectedConversionFactor: Double = 0.453592
        let actualConversionFactor = WeightUnit.pounds.conversionToKg
        
        #expect(abs(actualConversionFactor - expectedConversionFactor) < 0.000001,
                "Conversion factor should match standard lbs to kg conversion")
    }
}
#endif
