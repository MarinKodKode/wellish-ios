//
//  RoutineViewModel+Save.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 08/10/25.
//

import Foundation

extension RoutineViewModel {
    
    public func saveRoutine() async -> Bool {
        
        //Turn on loading spinner
        
        guard canSave else {
            //Throw alert
            return false
        }
        
        let validation = validategymActivity()
        
        if !validation.isValid {
            //Throw alert
            return false
        }
        
        isSaving = true
        
        preparegymActivityForSave()
        
        let saveLocally = await service.saveRoutineLocally(gymActivity)
        
        let saveRemote = await service.saveRoutineFirebase(gymActivity)
        
        isSaving = false
        
        if saveLocally {
            //Display success animation
            if saveRemote {
                //Display success animation
            }else{
                //Report to Analitycs
                // Display toast for untrusted connection
            }
            //turn off loading spinner
            //Dismiss view
            return true
        } else{
            //Display alert
            //Report to Analitycs
            //turn off loading spinner
            //Dismiss view
            return false
        }
    }
}
