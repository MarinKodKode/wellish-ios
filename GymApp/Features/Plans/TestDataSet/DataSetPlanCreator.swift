//
//  DataSetPlanCreator.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/10/25.
//

import Foundation


struct ActivityDataset {
    
    static let runningActivities: [RunningActivity] = [
        
        RunningActivity(
            id: "run_001",
            name: "Easy Run Matutino",
            description: "Carrera suave de recuperación a ritmo conversacional. Ideal para días después de entrenamientos intensos.",
            tags: ["Recuperación", "Matutino", "Fácil"],
            runningType: .recovery,
            targetDistanceKm: 5.0,
            targetDurationMinutes: 35,
            targetPaceMinPerKm: "7:00",
            intensity: .low,
            terrain: .road,
            estimatedCalories: 350,
            source: .created,
            shareable: true
        ),
        
        // 2. Tempo Run - Carrera a ritmo tempo
        RunningActivity(
            id: "run_002",
            name: "5K Tempo",
            description: "Carrera a ritmo tempo para mejorar umbral de lactato. Mantén un esfuerzo sostenido pero controlado.",
            tags: ["Tempo", "Velocidad", "Avanzado"],
            runningType: .tempo,
            targetDistanceKm: 5.0,
            targetDurationMinutes: 30,
            targetPaceMinPerKm: "6:00",
            intensity: .high,
            terrain: .road,
            estimatedCalories: 450,
            source: .created,
            shareable: true
        ),
        
        // 3. Long Run - Carrera larga de fin de semana
        RunningActivity(
            id: "run_003",
            name: "Long Run Dominical",
            description: "Carrera larga a ritmo cómodo para construir resistencia aeróbica. Hidrátate bien antes, durante y después.",
            tags: ["Resistencia", "Domingo", "Fondista"],
            runningType: .longRun,
            targetDistanceKm: 15.0,
            targetDurationMinutes: 105,
            targetPaceMinPerKm: "7:00",
            intensity: .moderate,
            terrain: .mixed,
            elevationGainMeters: 150,
            estimatedCalories: 1050,
            source: .created,
            shareable: true
        ),
        
        // 4. Interval Training - Intervalos en pista
        RunningActivity(
            id: "run_004",
            name: "Intervalos 400m",
            description: "Sesión de intervalos de 400m para mejorar velocidad y VO2 max. 8 repeticiones con recuperación activa.",
            tags: ["Intervalos", "Pista", "VO2max", "Avanzado"],
            runningType: .intervals,
            targetDistanceKm: 6.0,
            targetDurationMinutes: 40,
            targetPaceMinPerKm: "5:00",
            intensity: .interval,
            terrain: .track,
            intervals: [
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2)
            ],
            estimatedCalories: 550,
            source: .template,
            globalActivityId: "template_run_004",
            shareable: true
        )
    ]
    
    // MARK: - Rest Activities
    
    static let restActivities: [RestActivity] = [
        
        // 1. Complete Rest - Descanso total
        RestActivity(
            id: "rest_001",
            name: "Descanso Total",
            description: "Día completo de descanso. Tu cuerpo necesita tiempo para recuperarse y adaptarse al entrenamiento.",
            tags: ["Recuperación", "Sueño", "Hidratación"],
            restType: .complete,
            suggestedActivities: [
                "Dormir 8-9 horas",
                "Mantener buena hidratación",
                "Nutrición adecuada",
                "Caminata muy ligera si es necesario"
            ],
            recoveryNotes: "Enfócate en dormir bien, comer saludable y mantenerte hidratado. Evita cualquier actividad física intensa.",
            source: .created,
            shareable: true
        ),
        
        // 2. Active Recovery - Descanso activo
        RestActivity(
            id: "rest_002",
            name: "Recuperación Activa",
            description: "Movimiento ligero para promover la circulación sanguínea y acelerar la recuperación muscular.",
            tags: ["Activo", "Circulación", "Ligero"],
            restType: .active,
            suggestedActivities: [
                "Caminata de 20-30 minutos",
                "Natación suave",
                "Yoga restaurativo",
                "Bicicleta a ritmo muy suave"
            ],
            suggestedDurationMinutes: 30,
            targetAreas: [.fullBody, .legs, .back],
            recoveryNotes: "Mantén la intensidad muy baja. El objetivo es moverse, no entrenar. RPE debe ser 3-4/10.",
            source: .template,
            globalActivityId: "template_rest_002",
            shareable: true
        ),
        
        // 3. Mobility Session - Movilidad completa
        RestActivity(
            id: "rest_003",
            name: "Sesión de Movilidad",
            description: "Trabajo completo de movilidad articular para mejorar rango de movimiento y prevenir lesiones.",
            tags: ["Movilidad", "Prevención", "Articulaciones"],
            restType: .mobility,
            suggestedActivities: [
                "Círculos de cadera (10 cada lado)",
                "Rotaciones de hombros (15 repeticiones)",
                "Movilidad de tobillo (2 min por lado)",
                "Cat-cow stretches (15 repeticiones)",
                "90/90 hip switches (10 cada lado)",
                "Thoracic rotations (10 cada lado)"
            ],
            suggestedDurationMinutes: 20,
            targetAreas: [.hips, .shoulders, .back, .core],
            recoveryNotes: "Realiza cada movimiento de forma controlada y consciente. No fuerces, busca amplitud natural.",
            source: .template,
            globalActivityId: "template_rest_003",
            shareable: true
        ),
        
        // 4. Foam Rolling - Liberación miofascial
        RestActivity(
            id: "rest_004",
            name: "Foam Rolling Tren Inferior",
            description: "Liberación miofascial enfocada en piernas para reducir tensión y mejorar recuperación post-carrera.",
            tags: ["Foam Roller", "Miofascial", "Piernas", "Post-Run"],
            restType: .foam,
            suggestedActivities: [
                "Rodillo en cuádriceps (2 min por pierna)",
                "Rodillo en isquiotibiales (2 min por pierna)",
                "Rodillo en banda iliotibial (IT band) (1.5 min por lado)",
                "Rodillo en glúteos (2 min por lado)",
                "Rodillo en pantorrillas (2 min por pierna)",
                "Bola de lacrosse en planta del pie (1 min por pie)"
            ],
            suggestedDurationMinutes: 15,
            targetAreas: [.quads, .hamstrings, .glutes, .calves],
            recoveryNotes: "Respira profundo durante el rodillo. Si encuentras puntos de tensión, mantén presión 20-30 segundos.",
            source: .created,
            shareable: true
        )
    ]
    
    // MARK: - Helper Methods
    
    /// Retorna todas las actividades como ActivityType
    static var allActivitiesAsTypes: [ActivityType] {
        let running = runningActivities.map { ActivityType.running($0) }
        let rest = restActivities.map { ActivityType.rest($0) }
        return running + rest
    }
    
    /// Retorna actividades filtradas por categoría
    static func activities(for category: ActivityCategory) -> [ActivityType] {
        switch category {
        case .gym:
            return gymActivities.map { .running($0) }
        case .running:
            return runningActivities.map { .running($0) }
        case .rest:
            return restActivities.map { .rest($0) }
        default:
            return []
        }
    }
    
    /// Retorna una actividad aleatoria del tipo especificado
    static func randomActivity(for category: ActivityCategory) -> ActivityType? {
        activities(for: category).randomElement()
    }
}
