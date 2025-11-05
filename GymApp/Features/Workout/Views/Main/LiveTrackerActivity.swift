//
//  LiveTrackerActivity.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/11/25.
//

import Foundation
import SwiftUI

struct LiveTrackerActivity : View {
    
    let planElement : PlanElement
    
    var body : some View {
        Group {
            switch planElement.activity {
            case .gym(let gymActivity):
                GymLiveTrackerView(planElement: planElement)
            case .running(let runningActivity):
//                RunningActivityTrackingView(
//                    planElement: planElement,
//                    runningActivity: runningActivity
//                )
                Text("")
                
            case .cycling(let cyclingActivity):
//                CyclingActivityTrackingView(
//                    planElement: planElement,
//                    cyclingActivity: cyclingActivity
//                )
                Text("")
                
            case .swimming(let swimmingActivity):
//                SwimmingActivityTrackingView(
//                    planElement: planElement,
//                    swimmingActivity: swimmingActivity
//                )
                Text("")
                
            case .walking(let walkingActivity):
//                WalkingActivityTrackingView(
//                    planElement: planElement,
//                    walkingActivity: walkingActivity
//                )
                Text("")
                
            case .rest(let restActivity):
//                RestActivityTrackingView(
//                    planElement: planElement,
//                    restActivity: restActivity
//                )
                Text("")
                
            }
        }
    }
}
