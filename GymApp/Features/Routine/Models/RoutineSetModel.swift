//
//  RoutineSetModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
//

import Foundation
import FirebaseFirestore

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
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case exercise
        case series
        case restBetweenSeriesSeconds
        case notes
        case intensityTechnique
    }
    
    public var estimatedVolumeKg: Double {
        series.reduce(0) { $0 + $1.estimatedVolumeKg }
    }
    
    public var totalReps: Int {
        series.reduce(0) { $0 + $1.repetitions }
    }
    
    // MARK: - Firestore Helper
    
    /// Convierte el RoutineSet a un diccionario para Firestore
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "exercise": exercise.toDictionary(),
            "series": series.map { $0.toDictionary() }
        ]
        
        if let restBetweenSeriesSeconds = restBetweenSeriesSeconds {
            dict["restBetweenSeriesSeconds"] = restBetweenSeriesSeconds
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        if let intensityTechnique = intensityTechnique {
            dict["intensityTechnique"] = intensityTechnique.rawValue
        }
        
        return dict
    }
}
