//
//  PlanCreatorViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation


public final class PlanCreatorViewModel : ObservableObject {
    
    @Published var plan: Plan
    
    init() {
        self.plan = Plan(name: "", goal: .general, durationWeeks: 4, activitiesPerWeek: 3)
    }
    
    public func initView(){
        
    }
    
    public func savePlan() async -> Bool {
        
        return true
    }
}
