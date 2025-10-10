//
//  RoutineViewModel+Save.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 08/10/25.
//

import Foundation

extension RoutineViewModel {
    
    public func saveRoutine() async -> Bool {
        guard canSave else {
            errorMessage = "Plase provide a name and at least one exercise."
            return false
        }
        
        //Validate
        let validation = validateRoutine()
        if !validation.isValid {
            errorMessage = validation.errors.joined(separator: "\n")
            return false
        }
        
        isSaving = true
        errorMessage = nil
        prepareRoutineForSave()
        
        var savedSuccessfully = false
        var errors : [String] = []
        
        print("Saving routine")
        
        //Save locally first
        do {
            try await localStorageService.saveRoutine(routine)
            savedSuccessfully = true
        }catch{
            errors.append("Local: \(error.localizedDescription)")
        }
        
        //Try to save into FirebaseStorage (online required)
        do {
            _ = try await firestoreService.uploadRoutinesWithID(routine)
            isOnline = true
            lastSyncDate = Date()
        }catch {
            errors.append("Firebase: \(error.localizedDescription)")
            isOnline = false
        }
        
        isSaving = false
        
        if savedSuccessfully {
            if errors.isEmpty {
                print("Routine saved successfully.")
            }else{
                print("Routine saved successfully in localStorage. But some errors occurred in another process.")
                errorMessage = "Saved Locally: \(errors.joined(separator: ","))"
            }
            return true
        }else{
            errorMessage = "Error saving routine \(errors.joined(separator: ","))"
            return false
        }
    }
    
}
