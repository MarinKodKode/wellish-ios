//
//  MetricsHistoryViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/11/25.
//

import Foundation

class MetricsHistoryViewModel : ObservableObject {
    
    @Published var completedActivitiesLoaded : Bool = false
    @Published var statisticsSummaryLoaded : Bool = false
    @Published var completedActivities :  [PlanElement] = []
    
    private let planService = PlanService()
    
    func initView() async {
        await loadCompletedActivities()
        
    }
    
    @MainActor
    func loadCompletedActivities() async {
        
        let plans = await planService.getPlans()
        let activePlans = plans.filter{$0.isBeingTracked == true}
        for activePlan in activePlans {
              completedActivities = activePlan.elements.filter{
                $0.completed == true
            }
        }
        statisticsSummaryLoaded = true
        completedActivitiesLoaded = true
        
    }
}
