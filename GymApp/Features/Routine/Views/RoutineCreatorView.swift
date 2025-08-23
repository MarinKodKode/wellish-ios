//
//  RoutineCreator.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 11/08/25.
//

import SwiftUI

public struct RoutineCreatorView: View {
    @ObservedObject var vm: RoutineViewModel

    // Small local UI state
    @State private var showingExercisePicker = false
    @State private var selectedSetIndex: Int? = nil
    @State private var newTagText: String = ""
    @State private var showRoutineCreator: Bool = false

    public init(viewModel: RoutineViewModel) {
        _vm = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ZStack {
                // ✅ Adaptive background (light/dark)
                Color(.systemBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        sectionView(title: "Routine") {
                            VStack(spacing: 16) {
                                TextField("Routine name", text: $vm.routine.name)
                                    .inputFieldStyle()

                                TextField("Description (optional)", text: $vm.routine.category.replacingNilWith(""))
                                    .inputFieldStyle()
                            }
                        }

                        sectionView(title: "Exercises & Sets") {
                            if vm.routine.sets.isEmpty {
                                Text("No sets yet. Add an exercise to begin.")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }

                            VStack(spacing: 12) {
                                ForEach(Array(vm.routine.sets.enumerated()), id: \.element.id) { index, _ in
                                    RoutineSetRowView(
                                        set: $vm.routine.sets[index],
                                        onAddSerie: { vm.addSerie(toSetAt: index) },
                                        onRemove: { vm.removeSet(at: index) },
                                        onEditSeria: { serieIndex, serie in
                                            vm.updateSerie(serie, at: serieIndex, inSet: index)
                                        }
                                    )
                                }
                            }

                            Button(action: { showingExercisePicker = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add exercise / set")
                                }
                                .foregroundColor(.blue)
                            }
                        }

                        sectionView(title: "Tags & Category") {
                            VStack(spacing: 12) {
                                HStack {
                                    TextField("Add tag", text: $newTagText)
                                        .inputFieldStyle()

                                    Button("Add") {
                                        vm.addTag(newTagText)
                                        newTagText = ""
                                    }
                                    .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    .foregroundColor(newTagText.isEmpty ? .secondary : .blue)
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(vm.routine.tags, id: \.self) { tag in
                                            TagChip(tag: tag) { vm.removeTag(tag) }
                                        }
                                    }
                                }

                                TextField("Category (e.g., Strength)", text: $vm.routine.category.replacingNilWith(""))
                                    .inputFieldStyle()
                            }
                        }

                        sectionView(title: "Metrics") {
                            VStack(spacing: 12) {
                                metricRow(title: "Estimated volume", value: String(format: "%.0f kg", vm.estimatedVolumeKg))
                                metricRow(title: "Total reps", value: "\(vm.totalReps)")
                                metricRow(title: "Total series", value: "\(vm.routine.totalSeriesCount)")
                            }
                        }

                        Button(action: {
                            Task {
                                let ok = await vm.save()
                                if ok {
                                    // Success feedback can be added later
                                }
                            }
                        }) {
                            if vm.isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Save Routine")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .disabled(!vm.canSave)
                        .padding(.top)
                    }
                    .padding(20)
                }
            }
            .navigationBarTitle("Create Routine", displayMode: .large)
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    showingExercisePicker = false
                    vm.addSet(with: exercise)
                }
            }
            .sheet(isPresented: $showRoutineCreator) {
                RoutineCreatorSheet(isPresented: $showRoutineCreator)
            }
            .alert(item: $vm.error) { err in
                Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Section View (Adaptive)

    @ViewBuilder
    private func sectionView<Content: View>(title: some View, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            title
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)

            content()
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
        }
    }

    private func sectionView(title: String, @ViewBuilder content: () -> some View) -> some View {
        sectionView(title: Text(title), content: content)
    }

    private func metricRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Subviews (Theme-Safe)

private struct TagChip: View {
    let tag: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(tag)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(16)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(4)
    }
}

private struct RoutineSetRowView: View {
    @Binding var set: RoutineSet
    var onAddSerie: () -> Void
    var onRemove: () -> Void
    var onEditSeria: (_ serieIndex: Int, _ serie: Serie) -> Void

    @State private var expanded = false

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(set.exercise.name)
                        .font(.headline)
                    if let equipment = set.exercise.equipment, !equipment.isEmpty {
                        Text(equipment)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(set.series.count) series")
                        .foregroundColor(.primary)
                    Text(String(format: "%.0f kg", set.estimatedVolumeKg))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Button(action: { expanded.toggle() }) {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if expanded {
                VStack(spacing: 8) {
                    ForEach($set.series) { $serie in
                        SerieRowView(serie: $serie) {
                            // Remove serie
                            if let index = set.series.firstIndex(where: { $0.id == serie.id }) {
                                set.series.remove(at: index)
                            }
                        }
                    }

                    HStack {
                        Button(action: onAddSerie) {
                            Label("Add serie", systemImage: "plus.circle")
                        }
                        Spacer()
                        Button("Remove set", role: .destructive, action: onRemove)
                    }
                }
                .padding(.top, 6)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
}

private struct SerieRowView: View {
    @Binding var serie: Serie
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Reps:")
                        .foregroundColor(.primary)
                    TextField("Reps", value: $serie.repetitions, formatter: NumberFormatter.integer)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Weight (kg):")
                        .foregroundColor(.primary)
                    TextField("kg", value: Binding(
                        get: { serie.idealWeightKg ?? 0.0 },
                        set: { serie.idealWeightKg = $0 > 0 ? $0 : nil }
                    ), formatter: NumberFormatter.decimal)
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Spacer()
            Text(String(format: "%.0f kg", serie.estimatedVolumeKg))
                .font(.caption)
                .foregroundColor(.secondary)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - ExercisePickerView (Adaptive)

private struct ExercisePickerView: View {
    var onSelect: (Exercise) -> Void

    private let library: [Exercise] = [
        Exercise(name: "Bench Press", category: "Chest", equipment: "Barbell", muscles: ["Chest","Triceps"]),
        Exercise(name: "Squat", category: "Legs", equipment: "Barbell", muscles: ["Quadriceps","Glutes"]),
        Exercise(name: "Deadlift", category: "Back", equipment: "Barbell", muscles: ["Back","Hamstrings"]),
        Exercise(name: "Overhead Press", category: "Shoulders", equipment: "Barbell", muscles: ["Deltoids"])
    ]

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            List(library) { ex in
                Button(action: {
                    onSelect(ex)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(ex.name)
                                .font(.headline)
                            if let category = ex.category {
                                Text(category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Pick exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Formatters

fileprivate extension NumberFormatter {
    static var integer: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .none
        f.minimum = 0
        f.maximumFractionDigits = 0
        return f
    }

    static var decimal: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
    }
}

// MARK: - Input Field Style

private extension View {
    func inputFieldStyle() -> some View {
        self
            .padding(12)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(12)
//            .textInputStyle(.plain) // Remove iOS 17 inset
    }
}

// MARK: - Optional String Binding

extension Binding where Value == String? {
    func replacingNilWith(_ defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

// MARK: - Error Wrapper

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

// MARK: - Preview

#Preview {
    RoutineCreatorView(viewModel: RoutineViewModel())
        .preferredColorScheme(.light)
}

#Preview {
    RoutineCreatorView(viewModel: RoutineViewModel())
        .preferredColorScheme(.dark)
}
