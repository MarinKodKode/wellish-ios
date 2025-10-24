//
//  PlanCreatorViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation


public final class PlanCreatorViewModel : ObservableObject {
    
    //UI Variables
    @Published var showRoutinePickerSheet : Bool = false
    
    @Published var plan: Plan
    @Published var isLoading : Bool = false
    @Published var showToast : Bool = false
    @Published var savedPlanSuccess : Bool = false
    
    @Published var selectedDay : Int?
    
    
    
    let service = PlanService()
    
    init() {
        self.plan = Plan(name: "", goal: .general, durationWeeks: 4, activitiesPerWeek: 3)
    }
    
    public func initView(){
        
    }
    
    public func savePlan() async {
        _ = await service.savePlanRemote(plan)
        _ = await service.savePlanRemote(plan)
    }
    
    public func createPlan(){
        
    }
    
    public func addActivityToPlan(_ activity: PlanActivity) {
        guard let day = self.selectedDay else {
            return
        }
//        
//        let planElement = PlanElement(
//            activity: .gym(activity),
//            day: day
//        )
//        self.plan.elements.append(planElement)
    }
}
