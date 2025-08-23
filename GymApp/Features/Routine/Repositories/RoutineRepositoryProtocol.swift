//
//  RoutineRepositoryProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation

public protocol RoutineRepositoryProtocol {
    func saveRoutine(_ routine: Routine) async throws -> Routine
    func fetchRoutines() async throws -> [Routine]
    func fetchRoutine(id: String) async throws -> Routine?
    // TODO: add update/delete when wiring to Firebase
}
