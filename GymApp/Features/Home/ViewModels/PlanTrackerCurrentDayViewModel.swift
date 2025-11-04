//
//  PlanTrackerCurrentDayViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 03/11/25.
//

import Foundation

public class PlanTrackerCurrentDayViewModel : ObservableObject{
    
    @Published var activePlans : [Plan] = PlanDataset().getPlans().filter{
        $0.isBeingTracked == true
    }
    
    @Published var todayActivities : [TodayActivityModel] = []
    
    func fecthActivePlans() -> [Plan] {
        return PlanDataset().getPlans().filter{$0.isBeingTracked == false}
    }
    
    
    
    public func initView() {
        todayActivities = buildTodayActivites()
        activePlans = fecthActivePlans()
    }
    
    func buildTodayActivites() -> [TodayActivityModel] {
        let planes : [Plan] = PlanDataset().getPlans().filter{
            $0.isBeingTracked == true
        }
        
        var activ : [TodayActivityModel] = []
        
        for activePlan in planes {
            guard let element = activePlan.upcomingActivity() else {
                continue
            }
            
            let title = element.activity.displayName
            
            activ.append(
                    TodayActivityModel(
                        title: title,
                        calories: element.activity.estimatedCalories?.asString ?? "",
                        time: element.activity.estimatedDuration?.asString ?? "",
                        element: activePlan.upcomingActivity()!,
                        image: element.activity.imageURL ?? ""
                    )
                )
        }
        return activ
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
