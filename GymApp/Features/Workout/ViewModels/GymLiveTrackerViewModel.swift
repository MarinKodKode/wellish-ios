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
import Combine

class GymLiveTrackerViewModel: ObservableObject {
    
    // MARK: - Singleton
    static let shared = GymLiveTrackerViewModel()
    
    // MARK: - Published Properties
    @Published var currentExerciseIndex = 0
    @Published var currentSet = 1
    @Published var isTimerRunning = false
    @Published var elapsedTime = 0
    @Published var restTimer = 10
    @Published var isResting = false
    @Published var showSetComplete = false
    @Published var showWorkoutComplete = false
    @Published var completedSets: [Int: [Int]] = [:]
    @Published var currentPlanElement: PlanElement?
    @Published var currentGymActivity: GymActivity? = PlanDataset().gymTemplates[0]
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var restTimerInstance: Timer?
    private var currentActivity: Activity?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var totalSets: Int {
        guard let gymActivity = currentGymActivity else { return 0 }
        return gymActivity.sets.reduce(0) { $0 + $1.series.count }
    }
    
    var completedSetsCount: Int {
        completedSets.values.reduce(0) { $0 + $1.count }
    }
    
    var progress: Double {
        guard totalSets > 0 else { return 0 }
        return Double(completedSetsCount) / Double(totalSets)
    }
    
    var caloriesBurned: Int {
        elapsedTime / 60 * 8
    }
    
    var currentRoutineSet: RoutineSet? {
        guard let gymActivity = currentGymActivity,
              currentExerciseIndex < gymActivity.sets.count else { return nil }
        return gymActivity.sets[currentExerciseIndex]
    }
    
    // MARK: - Init (Private for Singleton)
    private init() {
        requestNotificationPermissions()
        setupNotificationCategories()
        setupBackgroundHandling()
        restoreStateIfNeeded()
    }
    
    // MARK: - Public Methods
    
    /// Inicia un nuevo workout con un PlanElement
    func startWorkout(with planElement: PlanElement) {
        guard case .gym(let gymActivity) = planElement.activity else {
            print("⚠️ El PlanElement no contiene una GymActivity")
            return
        }
        
        // Resetear estado
        reset()
        
        // Configurar workout
        self.currentPlanElement = planElement
        self.currentGymActivity = gymActivity
        self.currentExerciseIndex = 0
        self.currentSet = 1
        self.elapsedTime = 0
        
        // Iniciar timer
        startTimer()
        
        // Guardar estado en UserDefaults
        saveState()
        
        print("✅ Workout iniciado: \(gymActivity.name)")
    }
    
    /// Inicia el timer principal
    private func startTimer() {
        isTimerRunning = true
        
        // Invalidar timer anterior si existe
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isResting else { return }
            self.elapsedTime += 1
            self.saveState() // Guardar estado cada segundo
        }
        
        // Mantener timer corriendo en background
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func pauseWorkout() {
        isTimerRunning = false
        timer?.invalidate()
        restTimerInstance?.invalidate()
        
        if isResting {
            UNUserNotificationCenter
                .current()
                .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        }
        
        saveState()
    }
    
    func resumeWorkout() {
        guard currentGymActivity != nil else { return }
        startTimer()
    }
    
    func completeSet() {
        guard let currentSet = currentRoutineSet else { return }
        
        // Registrar set completado
        var sets = completedSets[currentExerciseIndex] ?? []
        sets.append(self.currentSet)
        completedSets[currentExerciseIndex] = sets
        
        showSetComplete = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showSetComplete = false
        }
        
        // Verificar si hay más sets en este ejercicio
        if self.currentSet < currentSet.series.count {
            self.currentSet += 1
            // Obtener tiempo de descanso del set actual
            if let restTime = currentSet.series.first?.formattedRestTime {
                startRestTimer(duration: Int(restTime) ?? 60)
            }
        } else {
            // Pasar al siguiente ejercicio
            moveToNextExercise()
        }
        
        saveState()
    }
    
    private func moveToNextExercise() {
        guard let gymActivity = currentGymActivity else { return }
        
        if currentExerciseIndex < gymActivity.sets.count - 1 {
            currentExerciseIndex += 1
            currentSet = 1
            startRestTimer(duration: 60) // Descanso entre ejercicios
        } else {
            // Workout completado
            completeWorkout()
        }
    }
    
    func skipExercise() {
        guard let gymActivity = currentGymActivity,
              currentExerciseIndex < gymActivity.sets.count - 1 else { return }
        
        currentExerciseIndex += 1
        currentSet = 1
        isResting = false
        restTimer = 0
        restTimerInstance?.invalidate()
        
        UNUserNotificationCenter
            .current()
            .removeDeliveredNotifications(withIdentifiers: ["restComplete"])
        
        saveState()
    }
    
    private func completeWorkout() {
        isTimerRunning = false
        timer?.invalidate()
        restTimerInstance?.invalidate()
        showWorkoutComplete = true
        
        // Actualizar PlanElement con datos de rendimiento
        if var planElement = currentPlanElement {
            planElement.markCompleted(
                durationMinutes: elapsedTime / 60,
                calories: caloriesBurned,
                performanceNotes: "Completado con \(completedSetsCount) sets"
            )
            
            // Aquí guardarías en Firebase/Core Data
            print("✅ Workout completado: \(planElement.displayName)")
        }
        
        clearState()
    }
    
    private func startRestTimer(duration: Int) {
        isResting = true
        restTimer = duration
        
        restTimerInstance?.invalidate()
        
        restTimerInstance = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.restTimer > 0 {
                self.restTimer -= 1
            } else {
                self.isResting = false
                self.restTimerInstance?.invalidate()
            }
        }
        
        // Programar notificación para cuando termine el descanso
        scheduleRestCompleteNotification(duration: duration)
        
        RunLoop.current.add(restTimerInstance!, forMode: .common)
    }
    
    func skipRest() {
        isResting = false
        restTimer = 0
        restTimerInstance?.invalidate()
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
    }
    
    // MARK: - State Persistence
    
    private func saveState() {
        let state: [String: Any] = [
            "currentExerciseIndex": currentExerciseIndex,
            "currentSet": currentSet,
            "isTimerRunning": isTimerRunning,
            "elapsedTime": elapsedTime,
            "restTimer": restTimer,
            "isResting": isResting,
            "completedSets": completedSets.count,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        UserDefaults.standard.set(state, forKey: "GymTrackerState")
        
        // Guardar el PlanElement
        if let planElement = currentPlanElement,
           let data = try? JSONEncoder().encode(planElement) {
            UserDefaults.standard.set(data, forKey: "CurrentPlanElement")
        }
    }
    
    private func restoreStateIfNeeded() {
        guard let state = UserDefaults.standard.dictionary(forKey: "GymTrackerState"),
              let timestamp = state["timestamp"] as? TimeInterval else { return }
        
        // Solo restaurar si fue hace menos de 1 hora
        let elapsed = Date().timeIntervalSince1970 - timestamp
        guard elapsed < 3600 else {
            clearState()
            return
        }
        
        // Restaurar PlanElement
        if let data = UserDefaults.standard.data(forKey: "CurrentPlanElement"),
           let planElement = try? JSONDecoder().decode(PlanElement.self, from: data),
           case .gym(let gymActivity) = planElement.activity {
            
            self.currentPlanElement = planElement
            self.currentGymActivity = gymActivity
        }
        
        // Restaurar estado
        currentExerciseIndex = state["currentExerciseIndex"] as? Int ?? 0
        currentSet = state["currentSet"] as? Int ?? 1
        elapsedTime = state["elapsedTime"] as? Int ?? 0
        restTimer = state["restTimer"] as? Int ?? 0
        isResting = state["isResting"] as? Bool ?? false
        completedSets = state["completedSets"] as? [Int: [Int]] ?? [:]
        
        if state["isTimerRunning"] as? Bool == true {
            // Ajustar tiempo transcurrido desde que se guardó
            elapsedTime += Int(elapsed)
            startTimer()
        }
        
        print("✅ Estado restaurado del workout anterior")
    }
    
    private func clearState() {
        UserDefaults.standard.removeObject(forKey: "GymTrackerState")
        UserDefaults.standard.removeObject(forKey: "CurrentPlanElement")
    }
    
    func reset() {
        timer?.invalidate()
        restTimerInstance?.invalidate()
        
        currentExerciseIndex = 0
        currentSet = 1
        isTimerRunning = false
        elapsedTime = 0
        restTimer = 10
        isResting = false
        showSetComplete = false
        showWorkoutComplete = false
        completedSets = [:]
        currentPlanElement = nil
        currentGymActivity = nil
        
        clearState()
    }
    
    // MARK: - Background Handling
    
    private func setupBackgroundHandling() {
        // Observer para cuando la app entra en background
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.handleEnterBackground()
            }
            .store(in: &cancellables)
        
        // Observer para cuando la app vuelve a foreground
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.handleEnterForeground()
            }
            .store(in: &cancellables)
    }
    
    private func handleEnterBackground() {
        saveState()
        
        // Solicitar tiempo extra para continuar corriendo en background
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        print("📱 App en background - estado guardado")
    }
    
    private func handleEnterForeground() {
        restoreStateIfNeeded()
        endBackgroundTask()
        
        print("📱 App en foreground - estado restaurado")
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("✅ Notificaciones permitidas")
                } else if let error = error {
                    print("❌ Error en permisos de notificaciones: \(error)")
                }
            }
    }
    
    private func setupNotificationCategories() {
        let skipAction = UNNotificationAction(
            identifier: "SKIP_REST",
            title: "Saltar descanso",
            options: .foreground
        )
        
        let restCompleteCategory = UNNotificationCategory(
            identifier: "WORKOUT_REST_COMPLETE",
            actions: [skipAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter
            .current()
            .setNotificationCategories([restCompleteCategory])
    }
    
    private func scheduleRestCompleteNotification(duration: Int) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        
        let content = UNMutableNotificationContent()
        content.title = "¡Descanso terminado!"
        content.body = "Es hora de continuar con el siguiente set 💪"
        content.sound = .default
        content.categoryIdentifier = "WORKOUT_REST_COMPLETE"
        
        if let currentSet = currentRoutineSet {
            content.userInfo = [
                "exercise": currentSet.exercise.name,
                "set": currentSet.id,
                "restComplete": true
            ]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(duration),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "restComplete",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error al programar notificación: \(error)")
            } else {
                print("✅ Notificación programada para \(duration)s")
            }
        }
    }
    
    // MARK: - Deinit
    
    deinit {
        timer?.invalidate()
        restTimerInstance?.invalidate()
        endBackgroundTask()
    }
}
