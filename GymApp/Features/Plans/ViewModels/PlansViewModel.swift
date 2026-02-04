//
//  PlansViewViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import Foundation

public final class PlansViewViewModel : ObservableObject {
    
    @Published var routines : [GymActivity] = []
    @Published var plans : [Plan] = []
    
    let localStorageService = RoutineLocalStorageService()
    let firestoreService = RoutineFirestoreService()
    
    let routineService = RoutineService()
    let plansService = PlanService()
    
    @MainActor
    public func initView(){
        Task   {
            await prepareRoutinesToShow()
            await preparePlansToShow()
        }
    }
    
    @MainActor
    public func prepareRoutinesToShow() async {
        self.routines = await routineService.getRoutines()
    }
    
    @MainActor
    public func preparePlansToShow() async {
        self.plans = await plansService.getPlans()
    }
    
    
}
