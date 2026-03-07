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
    @State private var showCalendar = false
    
    // Available quick tags
    private let availableTags = [
        "Good sleep", "Poor sleep", "Traveling", "Salty meal", "Stressed"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 18) {
                        Spacer()
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
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Log Weight")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.primary, .primary.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Quick and easy tracking")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 32, height: 32)
                    )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.top, 6)
    }
    
    private var weightInputCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "scalemass")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Weight")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                HStack {
                    TextField("Enter weight", text: $weightText)
                        .font(.system(size: 24, weight: .medium))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text("lbs")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                }
            }
        }
    }
    
    private var dateSelectionCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCalendar.toggle()
                        }
                    }) {
                        Image(systemName: showCalendar ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    .buttonStyle(.plain)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showCalendar.toggle()
                    }
                }
                
                if showCalendar {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
    }
    
    private var notesCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "note.text")
                        .font(.title2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Notes")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Text("(Optional)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                    
                    Spacer()
                }
                
                TextField("Sleep quality, travel, cycle phase, etc.", text: $notes, axis: .vertical)
                    .font(.body)
                    .textFieldStyle(.plain)
                    .lineLimit(4...8)
                    .foregroundStyle(.primary)
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
                removeTagFromNotes(tag)
            } else {
                selectedTags.insert(tag)
                addTagToNotes(tag)
            }
        }) {
            Text(tag)
                .font(.subheadline.weight(.medium))
                .foregroundColor(selectedTags.contains(tag) ? .white : .blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            selectedTags.contains(tag) ? 
                            AnyShapeStyle(LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )) : 
                            AnyShapeStyle(Color.clear)
                        )
                        .stroke(
                            selectedTags.contains(tag) ? Color.clear : .blue.opacity(0.6),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: selectedTags.contains(tag) ? .blue.opacity(0.3) : .clear,
                    radius: selectedTags.contains(tag) ? 4 : 0,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(.plain)
    }
    
    private var saveButton: some View {
        Button(action: saveEntry) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                
                Text("Save Entry")
                    .font(.headline.weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        isValidInput ? 
                        AnyShapeStyle(LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )) : 
                        AnyShapeStyle(Color.gray.opacity(0.6))
                    )
                    .shadow(
                        color: isValidInput ? .blue.opacity(0.3) : .clear,
                        radius: isValidInput ? 8 : 0,
                        x: 0,
                        y: 4
                    )
            )
        }
        .disabled(!isValidInput)
        .buttonStyle(.plain)
        .scaleEffect(isValidInput ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: isValidInput)
    }
    
    private var isValidInput: Bool {
        !weightText.isEmpty && Double(weightText) != nil
    }
    
    // MARK: - Tag Management Functions
    
    private func addTagToNotes(_ tag: String) {
        let tagText = "#\(tag.replacingOccurrences(of: " ", with: ""))"
        
        if notes.isEmpty {
            notes = tagText
        } else {
            // Add tag on a new line if notes aren't empty
            if !notes.hasSuffix("\n") && !notes.isEmpty {
                notes += " "
            }
            notes += tagText
        }
    }
    
    private func removeTagFromNotes(_ tag: String) {
        let tagText = "#\(tag.replacingOccurrences(of: " ", with: ""))"
        
        // Remove the tag from notes
        notes = notes.replacingOccurrences(of: tagText, with: "")
        
        // Clean up extra spaces and newlines
        notes = notes
            .replacingOccurrences(of: "  ", with: " ") // Multiple spaces to single
            .trimmingCharacters(in: .whitespacesAndNewlines) // Trim edges
    }
    
    private func saveEntry() {
        guard let weight = Double(weightText) else { return }
        
        let entry = WeightEntry(
            weight: weight,
            date: selectedDate,
            notes: notes.isEmpty ? nil : notes
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

#Preview {
    WeightLogView()
        .modelContainer(for: WeightEntry.self, inMemory: true)
}
