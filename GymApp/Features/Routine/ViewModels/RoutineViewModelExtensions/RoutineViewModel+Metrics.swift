//
//  RoutineViewModel+Metrics.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension RoutineViewModel {
    
    public var estimatedVolumeKg : Double {
        routine.estimatedVolumeKg
    }
    
    public var totalReps : Int {
        routine.totalReps
    }
    
    public func calculateEstimatedDuration() -> Int {
        let totalSeries = routine.sets.reduce(0) { $0 + $1.series.count}
        let avgTimePerSerie = 45
        
        let totalRestTime = routine.sets.reduce(0) { total, set in
            let restTime = set.restBetweenSeriesSeconds ?? 90
            let seriesCount = max(0, set.series.count - 1)
            return total + (restTime * seriesCount)
        }
        
        let totalSeconds = (totalSeries * avgTimePerSerie) + totalRestTime
        return max(1, (totalSeconds + 59) / 60)
    }
    
    // Determine main muscular group
    
    public  func determinePrimaryMuscularGroup() -> String {
        let muscles = routine.sets.flatMap{ $0.exercise.muscles}
        guard !muscles.isEmpty else { return "General" }
        
        var muscleCount : [String : Int] = [:]
        muscles.forEach { muscle in
            muscleCount[muscle, default: 0] += 1
        }
        
        return muscleCount.max(by: { $0.value < $1.value})?.key ??
        muscles.first ?? "General"
    }
}
