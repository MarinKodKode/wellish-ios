//
//  RoutineViewModel+Tags&Categories.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension RoutineViewModel {
        
    public func addTag(_ tag : String){
        let t = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, !routine.tags.contains(t) else { return }
        routine.tags.append(t)
        routine.updatedAt = Date()
    }
    
    public func removeTag(_ tag : String ){
        routine.tags.removeAll{ $0 == tag }
        routine.updatedAt = Date()
    }
    
}
