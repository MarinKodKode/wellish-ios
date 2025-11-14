//
//  PlanTrackerCurrentDayViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 03/11/25.
//

import Foundation

public class PlanTrackerCurrentDayViewModel : ObservableObject{
    
    private let planService  : PlanService = PlanService()
    
    @Published var activePlans : [Plan] = PlanDataset().getPlans().filter{
        $0.isBeingTracked == true
    }
    
    @Published var todayActivities : [TodayActivityModel] = []
    
    func fecthActivePlans() async -> [Plan] {
        let plans = await planService.getPlans()
        return plans.filter{$0.isBeingTracked == true}
    }
    
    
    
    public func initView() async {
        todayActivities = await buildTodayActivites()
        activePlans = await fecthActivePlans()
    }
    
    func buildTodayActivites() async -> [TodayActivityModel] {
        let planes : [Plan] = await fecthActivePlans()
      
        var active : [TodayActivityModel] = []
        
        for activePlan in planes {
            guard let element = activePlan.upcomingActivity() else {
                continue
            }
            let title = element.activity.displayName
            active.append(
                    TodayActivityModel(
                        title: title,
                        calories: element.activity.estimatedCalories?.asString ?? "",
                        time: element.activity.estimatedDuration?.asString ?? "",
                        element: activePlan.upcomingActivity()!,
                        image: element.activity.imageURL ?? ""
                    )
                )
        }
        return active
    }
}

struct TodayActivityModel : Identifiable, Codable {
    var id = UUID()
    var title : String
    var calories : String
    var time : String
    var element : PlanElement
    var image : String
}
