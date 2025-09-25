//
//  MetricsSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView {
    
    var metricsSection: some View {
        enhancedSectionView(
            title: StringConstants.routineWorkoutMetrics,
            icon: "chart.bar.fill",
            iconColor: .fitnessSuccess
        ) {
            VStack(spacing: 16) {
                metricCard(
                    title: StringConstants.routineStimatedVolume,
                    value: String(format: "%.0f kg", vm.estimatedVolumeKg),
                    icon: "scalemass.fill",
                    color: .fitnessSuccess
                )
                
                HStack(spacing: 16) {
                    metricCard(
                        title: StringConstants.routineTotalRepetitions,
                        value: "\(vm.totalReps)",
                        icon: "repeat",
                        color: .primaryFitnessBlue
                    )
                    
                    metricCard(
                        title: StringConstants.routineTotalSeries,
                        value: "\(vm.routine.totalSeriesCount)",
                        icon: "list.number",
                        color: .energyFitnessOrange
                    )
                }
            }
        }
    }
    
}
