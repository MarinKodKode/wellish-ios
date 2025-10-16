//
//  RoutineViewModel+CRUDHelpers.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation


extension RoutineViewModel {
    
    public func validateRoutine() -> (isValid : Bool, errors : [String]){
        
        var errors : [String] = []
        
        if routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name cannot be empty")
        }
        
        if routine.sets.isEmpty {
            errors.append("Need at least one exercise")
        }
        
        for (index, set) in routine.sets.enumerated(){
            if set.series.isEmpty{
                errors.append("\(set.exercise.name) must have at least one serie")
            }
        }
        return (errors.isEmpty, errors)
    }
    
    public func prepareRoutineForSave(){

        routine.updatedAt = Date()
        
        if routine.musclesWorked?.isEmpty ?? true {
            let allMuscles = Set(routine.sets.flatMap{ $0.exercise.muscles })
            routine.musclesWorked = Array(allMuscles).sorted()
        }
        
        //Calculate stimated duration if empty
        if routine.estimatedDurationMinutes == nil {
            routine.estimatedDurationMinutes = calculateEstimatedDuration()
        }
        
        // Asignar creator si está disponible (descomentar cuando tengas Firebase Auth)
        // if routine.creator == nil {
        //     routine.creator = Auth.auth().currentUser?.uid
        // }
        
        // Si no hay categoría, tomar del primer ejercicio
        if routine.category == nil || routine.category?.isEmpty ?? true {
            routine.category = routine.sets.first?.exercise.category
        }
        
        // Grupo muscular afectado (tomar el más común)
        if routine.muscularGroupAffected == nil {
            routine.muscularGroupAffected = determinePrimaryMuscularGroup()
        }
    }
    
    public func addSet(with exercise : Exercise){
        let newSet = RoutineSet(exercise: exercise)
        routine.sets.append(newSet)
        routine.updatedAt = Date()
    }
    
    public func removeSet(at index : Int){
        guard routine.sets.indices.contains(index) else { return }
        routine.sets.remove(at: index)
        routine.updatedAt = Date()
    }
    
    public func addSerie(toSetAt setIndex : Int) {
        guard routine.sets.indices.contains(setIndex) else { return }
        routine.sets[setIndex].series.append(Serie())
        routine.updatedAt = Date()
    }
    
    public func removeSerie(at serieIndex : Int, inSet setIndex : Int){
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series.remove(at: serieIndex)
        routine.updatedAt = Date()
    }
    
    public func updateSerie(_ serie : Serie, at serieIndex : Int, inSet setIndex : Int){
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series[serieIndex] = serie
        routine.updatedAt = Date()
    }
    
    public var isValidName : Bool {
        !routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var canSave : Bool {
        isValidName && !routine.sets.isEmpty && !isSaving
    }
    
}
