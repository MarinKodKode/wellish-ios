//
//  RoutineRepository.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation

public final class MockRoutineRepository: RoutineRepositoryProtocol {
    private var storage: [String: Routine] = [:]

    public init() {}

    public func saveRoutine(_ routine: Routine) async throws -> Routine {
        var r = routine
        r.updatedAt = Date()
        storage[r.id] = r
        return r
    }

    public func fetchRoutines() async throws -> [Routine] {
        Array(storage.values).sorted { $0.createdAt > $1.createdAt }
    }

    public func fetchRoutine(id: String) async throws -> Routine? {
        storage[id]
    }
}
