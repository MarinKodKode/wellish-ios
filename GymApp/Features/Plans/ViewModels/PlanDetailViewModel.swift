//
//  PlanDetailViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 13/11/25.
//

import Foundation

class PlanDetailViewModel : ObservableObject {
    
    @Published var plan : Plan?  

    
    private let planService = PlanService()
    
    func fetchPlan(_ id : String) async -> Plan? {
        do {
            return try await planService.fetchPlan(by: id)
        }catch{
            return nil
        }
    }
    
    func startTrackingPlan(_ plan : Plan) async  -> Bool {
        
        let plan = await fetchPlan(plan.id)
        
        guard var plan = plan else {
            return false
        }
        
        plan.isBeingTracked = true
        
        return await planService.updatePlan(plan)
        
    }
    
    public func markElementAsCompleted(_ plan : Plan, _ planElement : PlanElement) async -> Bool {
        guard var mutablePlan = await fetchPlan(plan.id) else {
            return false
        }
        mutablePlan.markElementCompleted(id: planElement.id, completed: true)
        return await planService.updatePlan(mutablePlan)
    }
}
