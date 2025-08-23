//
//  RoutineCreatorSheet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 11/08/25.
//  Corrected version (model/view binding fixes, exercise picker, dark styling).
//

import SwiftUI

public struct RoutineCreatorSheet: View {
    @Binding var isPresented: Bool
    @StateObject private var vm = RoutineViewModel()

    // Exercise picker state
    @State private var showingExercisePicker: Bool = false
    @State private var exercisePickerTargetSetIndex: Int? = nil // nil -> add new set

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    public var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerView

                        nameAndCategorySection

                        setsSection

                        tagsSection

                        saveButton
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    if let index = exercisePickerTargetSetIndex {
                        // change existing set's exercise
                        guard vm.routine.sets.indices.contains(index) else { return }
                        vm.routine.sets[index].exercise = exercise
                    } else {
                        // add new set with chosen exercise
                        vm.addSet(with: exercise)
                    }
                    // reset
                    exercisePickerTargetSetIndex = nil
                    showingExercisePicker = false
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Header / Intro
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Create Your Routine")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text("Add exercises, sets, reps, and optional weights.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - Name / Category
    private var nameAndCategorySection: some View {
        VStack(spacing: 16) {
            inputCard(title: "Routine Name") {
                TextField("Enter name", text: $vm.routine.name)
                    .foregroundColor(.white)
                    .autocapitalization(.words)
            }

            inputCard(title: "Category") {
                TextField("e.g., Strength", text: $vm.routine.category.replacingNilWith(""))
                    .foregroundColor(.white)
            }

            inputCard(title: "Description (optional)") {
                TextField("Short description", text: Binding(
                    get: { vm.routine.description ?? "" },
                    set: { vm.routine.description = $0.isEmpty ? nil : $0 }
                ))
                .foregroundColor(.white)
            }
        }
    }

    // MARK: - Sets / Series
    private var setsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sets")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(vm.routine.sets.count) items")
                    .foregroundColor(.gray)
            }

            if vm.routine.sets.isEmpty {
                Text("No sets yet. Add an exercise to begin.")
                    .foregroundColor(.secondary)
            }

            // iterate using indices so we can create stable Bindings
            ForEach(vm.routine.sets.indices, id: \.self) { index in
                let setBinding = Binding<RoutineSet>(
                    get: { vm.routine.sets[index] },
                    set: { vm.routine.sets[index] = $0 }
                )

                VStack(spacing: 12) {
                    HStack {
                        Text(setBinding.wrappedValue.exercise.name)
                            .foregroundColor(.white)
                            .font(.headline)

                        Spacer()

                        Button(action: {
                            // change existing set exercise
                            exercisePickerTargetSetIndex = index
                            showingExercisePicker = true
                        }) {
                            Text("Change")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                    }

                    // Series list (editable)
                    VStack(spacing: 8) {
                        ForEach(setBinding.wrappedValue.series.indices, id: \.self) { sIndex in
                            // create binding to each Serie
                            let serieBinding = Binding<Serie>(
                                get: { setBinding.wrappedValue.series[sIndex] },
                                set: { new in
                                    vm.routine.sets[index].series[sIndex] = new
                                }
                            )

                            SerieRowView(serie: serieBinding) {
                                // onDelete
                                vm.routine.sets[index].series.remove(at: sIndex)
                            }
                        }

                        HStack {
                            Button(action: {
                                vm.addSerie(toSetAt: index)
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Add serie")
                                }
                                .foregroundColor(.blue)
                            }

                            Spacer()

                            Button(action: {
                                // remove the whole set
                                withAnimation { vm.removeSet(at: index) }
                            }) {
                                Text("Remove set")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.top, 6)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(16)
            }

            // Add set: open picker (no target index => add new set)
            Button(action: {
                exercisePickerTargetSetIndex = nil
                showingExercisePicker = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Add Set")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    // MARK: - Tags
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tags")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            inputCard {
                HStack {
                    TextField("Add tag", text: $vm.tagsInput)
                        .foregroundColor(.white)

                    Button("Add") {
                        vm.addTag(vm.tagsInput)
                        vm.tagsInput = ""
                    }
                    .disabled(vm.tagsInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.routine.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    // MARK: - Save
    private var saveButton: some View {
        Button(action: {
            Task {
                let ok = await vm.save()
                if ok {
                    isPresented = false
                }
            }
        }) {
            Text(vm.isSaving ? "Saving..." : "Save Routine")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .disabled(!vm.canSave || vm.isSaving)
    }

    // MARK: - Helpers
    private func inputCard<Content: View>(title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            content()
        }
        .padding()
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(12)
    }
}

// MARK: - SerieRowView (reused)
fileprivate struct SerieRowView: View {
    @Binding var serie: Serie
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Reps:")
                        .foregroundColor(.white)
                    TextField("Reps", value: $serie.repetitions, formatter: NumberFormatter.integer)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                }
                HStack {
                    Text("Weight (kg):")
                        .foregroundColor(.white)
                    TextField("kg", value: Binding(get: { serie.idealWeightKg ?? 0.0 },
                                                  set: { new in serie.idealWeightKg = new > 0 ? new : nil }),
                              formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                }
            }
            Spacer()
            Text(String(format: "%.0f kg", serie.estimatedVolumeKg))
                .font(.caption)
                .foregroundColor(.gray)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
    }
}

// MARK: - Exercise Picker (mock)
fileprivate struct ExercisePickerView: View {
    var onSelect: (Exercise) -> Void

    // Basic mock library. Replace with real DB or Firestore lookup later.
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
                            Text(ex.name).font(.headline)
                            Text(ex.category ?? "").font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Pick exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}

// MARK: - NumberFormatters
fileprivate extension NumberFormatter {
    static var integer: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .none
        f.minimum = 0
        f.maximumFractionDigits = 0
        return f
    }

    static var q: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
    }
}

