//
//  gymActivityViewModel+CRUDHelpers.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation


extension RoutineViewModel {
    
    public func validategymActivity() -> (isValid : Bool, errors : [String]){
        
        var errors : [String] = []
        
        if gymActivity.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name cannot be empty")
        }
        
        if gymActivity.sets.isEmpty {
            errors.append("Need at least one exercise")
        }
        
        for (index, set) in gymActivity.sets.enumerated(){
            if set.series.isEmpty{
                errors.append("\(set.exercise.name) must have at least one serie")
            }
        }
        return (errors.isEmpty, errors)
    }
    
    public func preparegymActivityForSave(){

        gymActivity.updatedAt = Date()
        
        if gymActivity.musclesWorked?.isEmpty ?? true {
            let allMuscles = Set(gymActivity.sets.flatMap{ $0.exercise.muscles })
            gymActivity.musclesWorked = Array(allMuscles).sorted()
        }
        
        //Calculate stimated duration if empty
        if gymActivity.estimatedDurationMinutes == nil {
            gymActivity.estimatedDurationMinutes = calculateEstimatedDuration()
        }
        
        // Asignar creator si está disponible (descomentar cuando tengas Firebase Auth)
        // if gymActivity.creator == nil {
        //     gymActivity.creator = Auth.auth().currentUser?.uid
        // }
        
        // Si no hay categoría, tomar del primer ejercicio
        if gymActivity.category == nil || gymActivity.category?.isEmpty ?? true {
            gymActivity.category = gymActivity.sets.first?.exercise.category
        }
        
        // Grupo muscular afectado (tomar el más común)
        if gymActivity.muscularGroupAffected == nil {
            gymActivity.muscularGroupAffected = determinePrimaryMuscularGroup()
        }
    }
    
    public func addSet(with exercise : Exercise){
        let newSet = RoutineSet(exercise: exercise)
        gymActivity.sets.append(newSet)
        gymActivity.updatedAt = Date()
    }
    
    public func removeSet(at index : Int){
        guard gymActivity.sets.indices.contains(index) else { return }
        gymActivity.sets.remove(at: index)
        gymActivity.updatedAt = Date()
    }
    
    public func addSerie(toSetAt setIndex : Int) {
        guard gymActivity.sets.indices.contains(setIndex) else { return }
        gymActivity.sets[setIndex].series.append(Serie())
        gymActivity.updatedAt = Date()
    }
    
    public func removeSerie(at serieIndex : Int, inSet setIndex : Int){
        guard gymActivity.sets.indices.contains(setIndex),
              gymActivity.sets[setIndex].series.indices.contains(serieIndex) else { return }
        gymActivity.sets[setIndex].series.remove(at: serieIndex)
        gymActivity.updatedAt = Date()
    }
    
    public func updateSerie(_ serie : Serie, at serieIndex : Int, inSet setIndex : Int){
        guard gymActivity.sets.indices.contains(setIndex),
              gymActivity.sets[setIndex].series.indices.contains(serieIndex) else { return }
        gymActivity.sets[setIndex].series[serieIndex] = serie
        gymActivity.updatedAt = Date()
    }
    
    public var isValidName : Bool {
        !gymActivity.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var canSave : Bool {
        isValidName && !gymActivity.sets.isEmpty && !isSaving
    }
    
}
