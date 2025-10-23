//
//  PlanElement.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

public struct PlanElement: Identifiable, Codable, Hashable {
    
    public let id: String
    public var activity: PlanActivity
    
    public var day: Int
    public var scheduledTime: Date?
    
    // MARK:  Completion Tracking
    public var completed: Bool
    public var completedAt: Date?
    
    // MARK:  Performance Tracking
    public var actualDurationMinutes: Int?
    public var actualDistanceKm: Double?
    public var actualCalories: Int?
    public var rpe: Int?
    public var performanceNotes: String?
    
    // MARK:  Context
    public var notes: String?
    
    // MARK: Init
    public init(
        id: String = UUID().uuidString,
        activity: PlanActivity,
        day: Int,
        scheduledTime: Date? = nil,
        completed: Bool = false,
        completedAt: Date? = nil,
        actualDurationMinutes: Int? = nil,
        actualDistanceKm: Double? = nil,
        actualCalories: Int? = nil,
        rpe: Int? = nil,
        performanceNotes: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.activity = activity
        self.day = day
        self.scheduledTime = scheduledTime
        self.completed = completed
        self.completedAt = completedAt
        self.actualDurationMinutes = actualDurationMinutes
        self.actualDistanceKm = actualDistanceKm
        self.actualCalories = actualCalories
        self.rpe = rpe
        self.performanceNotes = performanceNotes
        self.notes = notes
    }
    
    // MARK: - Computed Properties
    
    /// Nombre a mostrar
    public var displayName: String {
        activity.displayName
    }
    
    /// Categoría
    public var activityCategory: String {
        activity.category
    }
    
    /// Músculos trabajados
    public var musclesWorked: [String] {
        activity.musclesWorked
    }
    
    /// Icono
    public var icon: String {
        activity.icon
    }
    
    /// Descripción de la actividad
    public var activityDescription: String? {
        activity.description
    }
    
    // MARK: - Performance Comparison (Esperado vs Conseguido)
    
    /// Duración esperada (del modelo base)
    public var expectedDuration: Int? {
        activity.estimatedDuration
    }
    
    /// Calorías esperadas (del modelo base)
    public var expectedCalories: Int? {
        activity.estimatedCalories
    }
    
    /// Ratio de rendimiento de duración (conseguido / esperado)
    public var durationPerformanceRatio: Double? {
        guard let actual = actualDurationMinutes,
              let expected = expectedDuration,
              expected > 0 else { return nil }
        return Double(actual) / Double(expected)
    }
    
    /// Diferencia en calorías (conseguido - esperado)
    public var caloriesVariance: Int? {
        guard let actual = actualCalories,
              let expected = expectedCalories else { return nil }
        return actual - expected
    }
    
    /// Indicador de sobre/bajo rendimiento en duración
    public var durationPerformanceStatus: PerformanceStatus? {
        guard let ratio = durationPerformanceRatio else { return nil }
        if ratio < 0.9 { return .underPerformed }
        if ratio > 1.1 { return .overPerformed }
        return .onTarget
    }
    
    /// Indicador de sobre/bajo rendimiento en calorías
    public var caloriesPerformanceStatus: PerformanceStatus? {
        guard let variance = caloriesVariance,
              let expected = expectedCalories,
              expected > 0 else { return nil }
        let ratio = Double(abs(variance)) / Double(expected)
        if variance < 0 && ratio > 0.1 { return .underPerformed }
        if variance > 0 && ratio > 0.1 { return .overPerformed }
        return .onTarget
    }
    
    // MARK: - Formatting Helpers
    
    /// Formato de día
    public var formattedDay: String {
        "Día \(day)"
    }
    
    /// Hora formateada
    public var formattedTime: String? {
        guard let scheduledTime = scheduledTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: scheduledTime)
    }
    
    /// Resumen de rendimiento (si está completado)
    public var performanceSummary: String? {
        guard completed else { return nil }
        
        var parts: [String] = []
        
        if let duration = actualDurationMinutes {
            parts.append("\(duration) min")
        }
        
        if let distance = actualDistanceKm {
            parts.append(String(format: "%.1f km", distance))
        }
        
        if let calories = actualCalories {
            parts.append("\(calories) kcal")
        }
        
        if let rpe = rpe {
            parts.append("RPE \(rpe)/10")
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    /// Resumen de comparación (esperado vs conseguido)
    public var comparisonSummary: String? {
        guard completed else { return nil }
        
        var parts: [String] = []
        
        if let ratio = durationPerformanceRatio, let expected = expectedDuration {
            let actual = actualDurationMinutes ?? 0
            let diff = actual - expected
            if diff != 0 {
                parts.append("Duración: \(diff > 0 ? "+" : "")\(diff) min")
            }
        }
        
        if let variance = caloriesVariance, variance != 0 {
            parts.append("Calorías: \(variance > 0 ? "+" : "")\(variance) kcal")
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    // MARK: - Methods
    
    /// Marcar como completado con datos de rendimiento
    public mutating func markCompleted(
        durationMinutes: Int? = nil,
        distanceKm: Double? = nil,
        calories: Int? = nil,
        rpe: Int? = nil,
        performanceNotes: String? = nil
    ) {
        self.completed = true
        self.completedAt = Date()
        self.actualDurationMinutes = durationMinutes
        self.actualDistanceKm = distanceKm
        self.actualCalories = calories
        self.rpe = rpe
        self.performanceNotes = performanceNotes
    }
    
    /// Resetear completación y datos de rendimiento
    public mutating func resetCompletion() {
        self.completed = false
        self.completedAt = nil
        self.actualDurationMinutes = nil
        self.actualDistanceKm = nil
        self.actualCalories = nil
        self.rpe = nil
        self.performanceNotes = nil
    }
    
    /// Validar RPE (debe estar entre 1 y 10)
    public mutating func setRPE(_ value: Int) {
        self.rpe = max(1, min(10, value))
    }
    
    // MARK: - Firestore Helper
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "day": day,
            "completed": completed
        ]
        
        // Serializar activity (esto dependerá de cómo manejes enums en Firebase)
        // Aquí hay un ejemplo básico:
        switch activity {
        case .routine(let routine):
            dict["activityType"] = "routine"
            dict["activityData"] = routine.toDictionary()
        case .exercise(let exercise):
            dict["activityType"] = "exercise"
            dict["activityData"] = exercise.toDictionary()
        case .cardio(let cardio):
            dict["activityType"] = "cardio"
            dict["activityData"] = try? JSONEncoder().encode(cardio)
        case .rest(let rest):
            dict["activityType"] = "rest"
            dict["activityData"] = try? JSONEncoder().encode(rest)
        }
        
        if let scheduledTime = scheduledTime {
            dict["scheduledTime"] = scheduledTime
        }
        
        if let completedAt = completedAt {
            dict["completedAt"] = completedAt
        }
        
        if let actualDurationMinutes = actualDurationMinutes {
            dict["actualDurationMinutes"] = actualDurationMinutes
        }
        
        if let actualDistanceKm = actualDistanceKm {
            dict["actualDistanceKm"] = actualDistanceKm
        }
        
        if let actualCalories = actualCalories {
            dict["actualCalories"] = actualCalories
        }
        
        if let rpe = rpe {
            dict["rpe"] = rpe
        }
        
        if let performanceNotes = performanceNotes {
            dict["performanceNotes"] = performanceNotes
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
}
