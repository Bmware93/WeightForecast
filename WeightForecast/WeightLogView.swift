//
//  WeightLogView.swift
//  WeightForecast
//
//  Created by Benia Morgan-Ware on 3/6/26.
//

import SwiftUI
import SwiftData

struct WeightLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var weightText: String = ""
    @State private var selectedDate: Date = Date()
    @State private var notes: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var showingDatePicker = false
    
    // Available quick tags
    private let availableTags = [
        "Good sleep", "Poor sleep", "Traveling", "Salty meal", "Stressed"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 18) {
                        header
                        
                        VStack(spacing: 15) {
                            // Weight Input Card
                            weightInputCard
                            
                            // Date Selection Card
                            dateSelectionCard
                            
                            // Notes Card
                            notesCard
                            
                            // Quick Tags
                            quickTagsSection
                            
                            Spacer(minLength: 40)
                            
                            // Privacy note
                            Text("Your data is stored locally and synced with Apple Health (if enabled)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                saveButton
                    .padding(.horizontal, 18)
                    .padding(.bottom, 16)
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Log Weight")
                    .font(.largeTitle.weight(.regular))
                    .foregroundStyle(.primary)
                
                Text("Quick and easy tracking")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.top, 6)
    }
    
    private var weightInputCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Weight")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack {
                    TextField("Enter weight", text: $weightText)
                        .font(.system(size: 24, weight: .regular))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                    
                    Spacer()
                    
                    Text("lbs")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var dateSelectionCard: some View {
        CardContainer {
            HStack(spacing: 16) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(selectedDate.formatted(date: .numeric, time: .omitted))
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    showingDatePicker = true
                }) {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onTapGesture {
            showingDatePicker = true
        }
    }
    
    private var notesCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Notes (Optional)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("Sleep quality, travel, cycle phase, etc.", text: $notes, axis: .vertical)
                    .font(.body)
                    .textFieldStyle(.plain)
                    .lineLimit(4...8)
            }
        }
    }
    
    private var quickTagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVStack(alignment: .leading, spacing: 12) {
                HStack {
                    ForEach(Array(availableTags.prefix(3)), id: \.self) { tag in
                        tagButton(for: tag)
                    }
                    Spacer()
                }
                
                HStack {
                    ForEach(Array(availableTags.suffix(2)), id: \.self) { tag in
                        tagButton(for: tag)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func tagButton(for tag: String) -> some View {
        Button(action: {
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
            } else {
                selectedTags.insert(tag)
            }
        }) {
            Text(tag)
                .font(.subheadline)
                .foregroundColor(selectedTags.contains(tag) ? .white : .blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(selectedTags.contains(tag) ? Color.blue : Color.clear)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
    
    private var saveButton: some View {
        Button(action: saveEntry) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.down")
                    .font(.headline)
                
                Text("Save Entry")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isValidInput ? Color.blue : Color.gray)
            )
        }
        .disabled(!isValidInput)
    }
    
    private var isValidInput: Bool {
        !weightText.isEmpty && Double(weightText) != nil
    }
    
    private func saveEntry() {
        guard let weight = Double(weightText) else { return }
        
        // Combine selected tags into notes
        var finalNotes = notes
        if !selectedTags.isEmpty {
            let tagsString = selectedTags.joined(separator: ", ")
            if finalNotes.isEmpty {
                finalNotes = tagsString
            } else {
                finalNotes += "\n\nTags: \(tagsString)"
            }
        }
        
        let entry = WeightEntry(
            weight: weight,
            date: selectedDate,
            notes: finalNotes.isEmpty ? nil : finalNotes
        )
        
        modelContext.insert(entry)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            // Handle error - you might want to show an alert
            print("Failed to save weight entry: \(error)")
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    WeightLogView()
        .modelContainer(for: WeightEntry.self, inMemory: true)
}