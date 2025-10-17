//
//  WorkoutOfTheDayViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
//

import Foundation
import ActivityKit
import UserNotifications
import UIKit

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
        
    ]
    
    private var timer: Timer?
    private var restTimerInstance: Timer?
    public  var currentActivity : Activity<WorkoutActivityAttributes>?
    
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
    
    init (){
        requestNotificationPermissions()
        setupNotificationCategories()
    }
    
    
    func startWorkout() {
        isTimerRunning = true
        startLiveActivity()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isResting else { return }
            self.elapsedTime += 1
            updateLiveActivity()
        }
    }
    
    func pauseWorkout() {
        isTimerRunning = false
        timer?.invalidate()
        
        if isResting {
            endLiveActivity()
            UNUserNotificationCenter
                .current()
                .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        }
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
                endLiveActivity()
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
            endLiveActivity()
            UNUserNotificationCenter
                .current()
                .removeDeliveredNotifications(withIdentifiers: ["restComplete"])
        }
    }
    
    private func startRestTimer(duration: Int) {
        isResting = true
        restTimer = duration
        restTimerInstance = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.restTimer > 0 {
                self.restTimer -= 1
                updateLiveActivity()
            } else {
                self.isResting = false
                self.restTimerInstance?.invalidate()
                updateLiveActivity()
            }
        }
    }
    
    func requestNotificationPermissions(){
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]){ granted, error in
            if granted {
                print("Notifications Allowed")
            }
        }
    }
    
    func setupNotificationCategories(){
        let restCompleteCategory = UNNotificationCategory(
            identifier: "WORKOUT_REST_COMPLETE",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter
            .current()
            .setNotificationCategories([restCompleteCategory])
    }
    
    func scheduleRestCompleteNotification(duration : Int ){
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        let content = UNMutableNotificationContent()
        content.title = "Descanso terminado, a darle!"
        content.body = "Vamos vamos que esas metas no llegan solas."
        content.sound = .default
        content.badge = NSNumber(
            value: UIApplication.shared.applicationIconBadgeNumber + 1
        )
        
        content.categoryIdentifier = "WORKOUT_REST_COMPLETE"
        
        content.userInfo = [
            "exercise" : currentExercise.name,
            "set" : currentSet,
            "restComplete" : true
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(duration),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "restComplete",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error {
                print("Error al programar notificación \(error)")
            }else{
                print("Notificación programada para \(duration)s")
            }
        }
    }
}
