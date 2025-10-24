

import Foundation
import FirebaseFirestore

public struct RestActivity: Activity {
    
    // MARK: - Activity Protocol Properties
    
    public let id: String
    public var name: String
    public var description: String?
    public var createdAt: Date
    public var updatedAt: Date
    public var tags: [String]
    public var source: ActivitySource
    public var globalActivityId: String?
    public var shareable: Bool
    public var clubId: String?
    public var creator: String?
    
    // MARK: - Activity Type
    
    public var activityType: ActivityCategory {
        .rest
    }
    
    // MARK: - UI Properties
    
    public var icon: String {
        switch restType {
        case .complete:
            return "bed.double.fill"
        case .active:
            return "figure.walk"
        case .mobility:
            return "figure.flexibility"
        case .stretching:
            return "figure.mind.and.body"
        case .foam:
            return "figure.rolling"
        case .massage:
            return "hand.raised.fill"
        case .sauna:
            return "flame.fill"
        case .ice:
            return "snowflake"
        }
    }
    
    public var colorHex: String {
        switch restType {
        case .complete:
            return "64748B" // Gris slate - Descanso completo
        case .active:
            return "22D3EE" // Cyan claro - Descanso activo
        case .mobility:
            return "A78BFA" // Púrpura claro - Movilidad
        case .stretching:
            return "C084FC" // Púrpura - Estiramientos
        case .foam:
            return "8B5CF6" // Violeta - Foam rolling
        case .massage:
            return "EC4899" // Rosa - Masaje
        case .sauna:
            return "F97316" // Naranja - Sauna
        case .ice:
            return "06B6D4" // Cyan - Baño de hielo
        }
    }
    
    // MARK: - Rest-Specific Properties
    
    /// Tipo de descanso
    public var restType: RestType
    
    /// Actividades sugeridas para este día de descanso
    public var suggestedActivities: [String]?
    
    /// Duración sugerida en minutos (para descanso activo/movilidad)
    public var suggestedDurationMinutes: Int?
    
    /// Áreas del cuerpo a trabajar (para movilidad/estiramientos)
    public var targetAreas: [BodyArea]?
    
    /// Notas adicionales de recuperación
    public var recoveryNotes: String?
    
    // MARK: - Activity Protocol Computed Properties
    
    public var estimatedDuration: Int? {
        suggestedDurationMinutes
    }
    
    public var estimatedCalories: Int? {
        // Descanso completo no quema calorías
        if restType == .complete {
            return nil
        }
        
        // Descanso activo/movilidad puede tener estimación
        guard let duration = suggestedDurationMinutes else { return nil }
        
        // Estimación conservadora para actividades de baja intensidad
        switch restType {
        case .active:
            return duration * 3 // ~3 kcal/min caminata suave
        case .mobility, .stretching, .foam:
            return duration * 2 // ~2 kcal/min actividad muy ligera
        case .massage, .sauna, .ice:
            return duration * 1 // ~1 kcal/min terapias pasivas
        case .complete:
            return nil
        }
    }
    
    // MARK: - Init
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        restType: RestType,
        suggestedActivities: [String]? = nil,
        suggestedDurationMinutes: Int? = nil,
        targetAreas: [BodyArea]? = nil,
        recoveryNotes: String? = nil,
        source: ActivitySource = .created,
        globalActivityId: String? = nil,
        shareable: Bool = false,
        clubId: String? = nil,
        creator: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.restType = restType
        self.suggestedActivities = suggestedActivities
        self.suggestedDurationMinutes = suggestedDurationMinutes
        self.targetAreas = targetAreas
        self.recoveryNotes = recoveryNotes
        self.source = source
        self.globalActivityId = globalActivityId
        self.shareable = shareable
        self.clubId = clubId
        self.creator = creator
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdAt
        case updatedAt
        case tags
        case restType
        case suggestedActivities
        case suggestedDurationMinutes
        case targetAreas
        case recoveryNotes
        case source
        case globalActivityId
        case shareable
        case clubId
        case creator
    }
    
    // MARK: - Computed Properties (Específicos de Rest)
    
    /// Indica si es un descanso completamente pasivo
    public var isPassiveRest: Bool {
        restType == .complete
    }
    
    /// Indica si requiere actividad física ligera
    public var requiresActivity: Bool {
        switch restType {
        case .complete, .massage, .sauna, .ice:
            return false
        case .active, .mobility, .stretching, .foam:
            return true
        }
    }
    
    /// Texto descriptivo del tipo de descanso
    public var restTypeDescription: String {
        switch restType {
        case .complete:
            return "Descanso total. Tu cuerpo necesita recuperarse completamente."
        case .active:
            return "Actividad ligera como caminar, nadar suave o yoga restaurativo."
        case .mobility:
            return "Trabajo de movilidad articular y flexibilidad."
        case .stretching:
            return "Sesión de estiramientos estáticos y dinámicos."
        case .foam:
            return "Auto-masaje con foam roller para liberar tensiones."
        case .massage:
            return "Masaje terapéutico o deportivo profesional."
        case .sauna:
            return "Terapia de calor para relajación muscular."
        case .ice:
            return "Crioterapia o baño de hielo para recuperación."
        }
    }
    
    /// Áreas del cuerpo formateadas
    public var formattedTargetAreas: String? {
        guard let areas = targetAreas, !areas.isEmpty else { return nil }
        return areas.map { $0.rawValue }.joined(separator: ", ")
    }
    
    // MARK: - Firestore Serialization
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "activityType": activityType.rawValue,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "tags": tags,
            "restType": restType.rawValue,
            "source": source.rawValue,
            "shareable": shareable
        ]
        
        if let description = description {
            dict["description"] = description
        }
        
        if let suggestedActivities = suggestedActivities {
            dict["suggestedActivities"] = suggestedActivities
        }
        
        if let suggestedDurationMinutes = suggestedDurationMinutes {
            dict["suggestedDurationMinutes"] = suggestedDurationMinutes
        }
        
        if let targetAreas = targetAreas {
            dict["targetAreas"] = targetAreas.map { $0.rawValue }
        }
        
        if let recoveryNotes = recoveryNotes {
            dict["recoveryNotes"] = recoveryNotes
        }
        
        if let globalActivityId = globalActivityId {
            dict["globalActivityId"] = globalActivityId
        }
        
        if let clubId = clubId {
            dict["clubId"] = clubId
        }
        
        if let creator = creator {
            dict["creator"] = creator
        }
        
        return dict
    }
}

// MARK: - Supporting Enums

/// Tipos de descanso y recuperación
public enum RestType: String, Codable, CaseIterable {
    case complete = "Descanso completo"
    case active = "Descanso activo"
    case mobility = "Movilidad"
    case stretching = "Estiramientos"
    case foam = "Foam rolling"
    case massage = "Masaje"
    case sauna = "Sauna"
    case ice = "Baño de hielo"
    
    /// Descripción corta del tipo
    public var shortDescription: String {
        switch self {
        case .complete: return "Sin actividad"
        case .active: return "Actividad ligera"
        case .mobility: return "Movilidad articular"
        case .stretching: return "Estiramientos"
        case .foam: return "Auto-masaje"
        case .massage: return "Masaje profesional"
        case .sauna: return "Terapia de calor"
        case .ice: return "Crioterapia"
        }
    }
    
    /// Duración sugerida por defecto (en minutos)
    public var defaultDuration: Int? {
        switch self {
        case .complete:
            return nil // Todo el día
        case .active:
            return 30 // 30 min de actividad ligera
        case .mobility:
            return 20 // 20 min de movilidad
        case .stretching:
            return 15 // 15 min de estiramientos
        case .foam:
            return 15 // 15 min de foam rolling
        case .massage:
            return 60 // 60 min de masaje
        case .sauna:
            return 20 // 20 min de sauna
        case .ice:
            return 10 // 10 min de baño de hielo
        }
    }
}

/// Áreas del cuerpo para trabajo de recuperación
public enum BodyArea: String, Codable, CaseIterable {
    case fullBody = "Cuerpo completo"
    case upperBody = "Tren superior"
    case lowerBody = "Tren inferior"
    case back = "Espalda"
    case shoulders = "Hombros"
    case arms = "Brazos"
    case core = "Core"
    case hips = "Caderas"
    case legs = "Piernas"
    case calves = "Pantorrillas"
    case glutes = "Glúteos"
    case hamstrings = "Isquiotibiales"
    case quads = "Cuádriceps"
    case chest = "Pecho"
    case neck = "Cuello"
    
    /// Icono SF Symbol sugerido
    public var icon: String {
        switch self {
        case .fullBody: return "figure.stand"
        case .upperBody: return "figure.arms.open"
        case .lowerBody: return "figure.walk"
        case .back: return "figure.strengthtraining.traditional"
        case .shoulders: return "figure.arms.open"
        case .arms: return "figure.strengthtraining.functional"
        case .core: return "figure.core.training"
        case .hips: return "figure.flexibility"
        case .legs: return "figure.walk"
        case .calves: return "figure.run"
        case .glutes: return "figure.strengthtraining.traditional"
        case .hamstrings: return "figure.run"
        case .quads: return "figure.strengthtraining.traditional"
        case .chest: return "heart.fill"
        case .neck: return "figure.mind.and.body"
        }
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension RestActivity {
    /// Descanso completo
    public static var completeRest: RestActivity {
        RestActivity(
            name: "Día de Descanso Total",
            description: "Recuperación completa sin actividad física",
            restType: .complete,
            recoveryNotes: "Enfócate en dormir bien y mantener buena hidratación"
        )
    }
    
    /// Descanso activo
    public static var activeRest: RestActivity {
        RestActivity(
            name: "Descanso Activo",
            description: "Caminata ligera y estiramientos",
            restType: .active,
            suggestedActivities: [
                "Caminata de 20-30 minutos",
                "Estiramientos suaves",
                "Yoga restaurativo"
            ],
            suggestedDurationMinutes: 30
        )
    }
    
    /// Movilidad
    public static var mobilitySession: RestActivity {
        RestActivity(
            name: "Sesión de Movilidad",
            description: "Trabajo de movilidad articular completo",
            restType: .mobility,
            suggestedActivities: [
                "Círculos de cadera",
                "Rotaciones de hombros",
                "Movilidad de tobillo",
                "Cat-cow stretches"
            ],
            suggestedDurationMinutes: 20,
            targetAreas: [.hips, .shoulders, .back]
        )
    }
    
    /// Foam rolling
    public static var foamRolling: RestActivity {
        RestActivity(
            name: "Foam Rolling",
            description: "Liberación miofascial de tren inferior",
            restType: .foam,
            suggestedActivities: [
                "Rodillo en cuádriceps",
                "Rodillo en isquiotibiales",
                "Rodillo en glúteos",
                "Rodillo en pantorrillas"
            ],
            suggestedDurationMinutes: 15,
            targetAreas: [.quads, .hamstrings, .glutes, .calves]
        )
    }
    
    /// Ejemplo genérico
    public static var example: RestActivity {
        activeRest
    }
}
#endif
