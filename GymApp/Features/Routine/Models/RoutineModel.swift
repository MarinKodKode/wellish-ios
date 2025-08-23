//
//  RoutineModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation

// MARK: - Exercise (Library)
public struct Exercise: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var category: String?
    public var equipment: String?
    public var muscles: [String]
    public var thumbnailURL: URL?

    public init(
        id: String = UUID().uuidString,
        name: String,
        category: String? = nil,
        equipment: String? = nil,
        muscles: [String] = [],
        thumbnailURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.equipment = equipment
        self.muscles = muscles
        self.thumbnailURL = thumbnailURL
    }
}

// MARK: - Serie (Atomic)
public struct Serie: Identifiable, Codable, Hashable {
    public let id: String
    public var repetitions: Int
    public var idealWeightKg: Double?
    public var performedWeightKg: Double?
    public var tempo: String?
    public var restSeconds: Int?

    public init(
        id: String = UUID().uuidString,
        repetitions: Int = 10,
        idealWeightKg: Double? = nil,
        performedWeightKg: Double? = nil,
        tempo: String? = nil,
        restSeconds: Int? = 60
    ) {
        self.id = id
        self.repetitions = repetitions
        self.idealWeightKg = idealWeightKg
        self.performedWeightKg = performedWeightKg
        self.tempo = tempo
        self.restSeconds = restSeconds
    }

    /// Estimated volume (kg) for this serie (uses idealWeightKg if available)
    public var estimatedVolumeKg: Double {
        guard let w = idealWeightKg else { return 0 }
        return Double(repetitions) * w
    }
}

// MARK: - RoutineSet (exercise + series)
public struct RoutineSet: Identifiable, Codable, Hashable {
    public let id: String
    public var exercise: Exercise
    public var series: [Serie]
    public var restBetweenSeriesSeconds: Int?
    public var notes: String?
    public var intensityTechnique: IntensityTechnique?

    public init(
        id: String = UUID().uuidString,
        exercise: Exercise,
        series: [Serie] = [Serie()],
        restBetweenSeriesSeconds: Int? = 90,
        notes: String? = nil,
        intensityTechnique: IntensityTechnique? = nil
    ) {
        self.id = id
        self.exercise = exercise
        self.series = series
        self.restBetweenSeriesSeconds = restBetweenSeriesSeconds
        self.notes = notes
        self.intensityTechnique = intensityTechnique
    }

    public var estimatedVolumeKg: Double {
        series.reduce(0) { $0 + $1.estimatedVolumeKg }
    }

    public var totalReps: Int {
        series.reduce(0) { $0 + $1.repetitions }
    }
}

// MARK: - Routine (top-level)
public struct Routine: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var description: String?
    public var createdAt: Date
    public var updatedAt: Date
    public var sets: [RoutineSet]
    public var tags: [String]
    public var category: String?
    public var estimatedDurationMinutes: Int?

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sets: [RoutineSet] = [],
        tags: [String] = [],
        category: String? = nil,
        estimatedDurationMinutes: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sets = sets
        self.tags = tags
        self.category = category
        self.estimatedDurationMinutes = estimatedDurationMinutes
    }

    // MARK: - Computed helpers
    public var estimatedVolumeKg: Double {
        sets.reduce(0) { $0 + $1.estimatedVolumeKg }
    }

    public var totalSeriesCount: Int {
        sets.reduce(0) { $0 + $1.series.count }
    }

    public var totalReps: Int {
        sets.reduce(0) { $0 + $1.totalReps }
    }

    public var formattedVolume: String {
        NumberFormatter.localizedString(
            from: NSNumber(value: estimatedVolumeKg),
            number: .decimal
        ) + " kg"
    }

    public var formattedDuration: String {
        guard let minutes = estimatedDurationMinutes else { return "—" }
        return "\(minutes) min"
    }

    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
}

// MARK: - Intensity techniques
public enum IntensityTechnique: String, Codable, CaseIterable {
    case none
    case dropSet = "Drop set"
    case superset = "Superset"
    case restPause = "Rest-pause"
    case pausedReps = "Paused reps"
}
