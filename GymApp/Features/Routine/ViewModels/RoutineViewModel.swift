//
//  RoutineViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
public final class RoutineViewModel: ObservableObject {
    // Input model being edited
    @Published public var routine: Routine

    // UI state
    @Published public var isSaving: Bool = false
    @Published public var errorMessage: String?
    @Published var error: ErrorWrapper?
    @Published var savedRoutines: [Routine] = routines
    @Published var tagsInput: String = ""

    private let repository: RoutineRepositoryProtocol

    public init(routine: Routine = Routine(name: "New Routine"),
                repository: RoutineRepositoryProtocol = MockRoutineRepository()) {
        self.routine = routine
        self.repository = repository
    }

    // MARK: - Convenience computed values
    public var isValidName: Bool {
        !routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var canSave: Bool {
        isValidName && !routine.sets.isEmpty && !isSaving
    }

    // MARK: - CRUD helpers
    public func addSet(with exercise: Exercise) {
        let newSet = RoutineSet(exercise: exercise)
        routine.sets.append(newSet)
    }

    public func removeSet(at index: Int) {
        guard routine.sets.indices.contains(index) else { return }
        routine.sets.remove(at: index)
    }

    public func addSerie(toSetAt setIndex: Int) {
        guard routine.sets.indices.contains(setIndex) else { return }
        routine.sets[setIndex].series.append(Serie())
    }

    public func removeSerie(at serieIndex: Int, inSet setIndex: Int) {
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series.remove(at: serieIndex)
    }

    public func updateSerie(_ serie: Serie, at serieIndex: Int, inSet setIndex: Int) {
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series[serieIndex] = serie
    }

    // MARK: - Metrics
    public var estimatedVolumeKg: Double {
        routine.estimatedVolumeKg
    }

    public var totalReps: Int {
        routine.totalReps
    }

    // MARK: - Templates & tags helpers
    public func addTag(_ tag: String) {
        let t = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, !routine.tags.contains(t) else { return }
        routine.tags.append(t)
    }

    public func removeTag(_ tag: String) {
        routine.tags.removeAll { $0 == tag }
    }

    // MARK: - Save
    public func save() async -> Bool {
        guard canSave else {
            errorMessage = "Please provide a name and at least one set."
            return false
        }
        isSaving = true
        errorMessage = nil
        do {
            let saved = try await repository.saveRoutine(routine)
            self.routine = saved
            isSaving = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isSaving = false
            return false
        }
    }
    

}
