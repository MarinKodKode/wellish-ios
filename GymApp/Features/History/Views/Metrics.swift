//
//  Metrics.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MetricsView: View {
    
    @Binding var showWorkoutTimer: Bool
//    @State private var selectedTimeframe = "Today"
//    @State private var selectedCalorieTimeframe = "Weekly"
//    @State private var isLoading : Bool = true
//    @EnvironmentObject private var navigatorRouter : NavigationRouter

    let plans = PlanDataset().getPlans()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        HeaderWidgetView()
                            .padding(.top, 20)
                        
                        Metrics_StatisticsCard(title: "Resumen")
                            .padding(.top, 20)
                        
                        Metrics_CaloriesChartView(tapped: false , title: "Estadisticas")
                        
                        Metrics_CompletedActivitiesView(title : "Actividades completadas")
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitle(StringConstants.metricsTitle)
        }
        .navigationBarHidden(true)
    }
    
   
    

}

#Preview {
    
    var showTimer = true
    
    MetricsView(showWorkoutTimer: .constant(showTimer))
}
