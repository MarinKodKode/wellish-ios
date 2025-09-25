
import SwiftUI

public struct RoutineCreatorSheet: View {
   
    @Binding var isPresented: Bool
    @StateObject private var vm = RoutineViewModel()

    @State private var showingExercisePicker: Bool = false
    @State private var exercisePickerTargetSetIndex: Int? = nil

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
                        guard vm.routine.sets.indices.contains(index) else { return }
                        vm.routine.sets[index].exercise = exercise
                    } else {
                        vm.addSet(with: exercise)
                    }
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
