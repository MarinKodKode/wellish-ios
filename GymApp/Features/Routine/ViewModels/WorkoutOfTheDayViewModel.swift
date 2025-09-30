//
//  WorkoutOfTheDayViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
//

import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var currentExerciseIndex = 0
    @Published var currentSet = 1
    @Published var isTimerRunning = false
    @Published var elapsedTime = 0
    @Published var restTimer = 10
    @Published var isResting = false
    @Published var showSetComplete = false
    @Published var showWorkoutComplete = false
    @Published var completedSets: [Int: [Int]] = [:]
    
    let exercises = [
        ExerciseLocal(name: "Bench Press", sets: 4, reps: 10, weight: 60, restTime: 90),
        ExerciseLocal(name: "Dumbbell Rows", sets: 4, reps: 12, weight: 25, restTime: 60),
        ExerciseLocal(name: "Shoulder Press", sets: 3, reps: 10, weight: 20, restTime: 60),
        ExerciseLocal(name: "Lateral Raises", sets: 3, reps: 15, weight: 10, restTime: 45),
        ExerciseLocal(name: "Bicep Curls", sets: 3, reps: 12, weight: 15, restTime: 45),
        ExerciseLocal(name: "Tricep Extensions", sets: 3, reps: 12, weight: 15, restTime: 45),
        ExerciseLocal(name: "Face Pulls", sets: 3, reps: 15, weight: 20, restTime: 45),
        ExerciseLocal(name: "Push-ups", sets: 3, reps: 20, weight: 0, restTime: 60)
    ]
    
    private var timer: Timer?
    private var restTimerInstance: Timer?
    
    var currentExercise: ExerciseLocal {
        exercises[currentExerciseIndex]
    }
    
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets }
    }
    
    var completedSetsCount: Int {
        completedSets.values.reduce(0) { $0 + $1.count }
    }
    
    var progress: Double {
        Double(completedSetsCount) / Double(totalSets)
    }
    
    var caloriesBurned: Int {
        elapsedTime / 60 * 8
    }
    
    func startWorkout() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isResting else { return }
            self.elapsedTime += 1
        }
    }
    
    func pauseWorkout() {
        isTimerRunning = false
        timer?.invalidate()
    }
    
    func completeSet() {
        
        var sets = completedSets[currentExerciseIndex] ?? []
        sets.append(currentSet)
        completedSets[currentExerciseIndex] = sets
        
        showSetComplete = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showSetComplete = false
        }
        
        if currentSet < currentExercise.sets {
            currentSet += 1
            startRestTimer(duration: currentExercise.restTime)
        } else {
            if currentExerciseIndex < exercises.count - 1 {
                currentExerciseIndex += 1
                currentSet = 1
                startRestTimer(duration: 15)
            } else {
                isTimerRunning = false
                timer?.invalidate()
                showWorkoutComplete = true
            }
        }
    }
    
    func skipExercise() {
        if currentExerciseIndex < exercises.count - 1 {
            currentExerciseIndex += 1
            currentSet = 1
            isResting = false
            restTimer = 0
            restTimerInstance?.invalidate()
        }
    }
    
    private func startRestTimer(duration: Int) {
        isResting = true
        restTimer = duration
        restTimerInstance = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.restTimer > 0 {
                self.restTimer -= 1
            } else {
                self.isResting = false
                self.restTimerInstance?.invalidate()
            }
        }
    }
}
