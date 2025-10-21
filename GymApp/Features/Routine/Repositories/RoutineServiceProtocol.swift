//
//  RoutineServiceProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import Foundation

protocol RoutineServiceProtocol {
    
    func fetchRoutines() async throws -> [Routine]
    
    func fetchRoutine(by id: String) async throws -> Routine?
    
    func saveRoutineLocally(_ routine : Routine) async -> Bool
    
    func saveRoutineFirebase(_ routine : Routine) async -> Bool
    
    
    
}
