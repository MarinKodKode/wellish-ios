//
//  RestActivity.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

public struct RestActivity: Activity {

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
    public var imageURL: String?

    public var activityType: ActivityCategory { .rest }

    public var icon: String {
        switch restType {
        case .complete:    return "bed.double.fill"
        case .active:      return "figure.walk"
        case .mobility:    return "figure.flexibility"
        case .stretching:  return "figure.mind.and.body"
        case .foam:        return "figure.rolling"
        case .massage:     return "hand.raised.fill"
        case .sauna:       return "flame.fill"
        case .ice:         return "snowflake"
        }
    }

    public var colorHex: String {
        switch restType {
        case .complete:   return "64748B"
        case .active:     return "22D3EE"
        case .mobility:   return "A78BFA"
        case .stretching: return "C084FC"
        case .foam:       return "8B5CF6"
        case .massage:    return "EC4899"
        case .sauna:      return "F97316"
        case .ice:        return "06B6D4"
        }
    }

    // MARK: - Rest-Specific Properties

    public var restType: RestType
    public var suggestedActivities: [String]?
    public var suggestedDurationMinutes: Int?
    public var targetAreas: [BodyArea]?
    public var recoveryNotes: String?

    public var estimatedDuration: Int? { suggestedDurationMinutes }

    public var estimatedCalories: Int? {
        guard restType != .complete,
              let duration = suggestedDurationMinutes else { return nil }
        switch restType {
        case .active:                        return duration * 3
        case .mobility, .stretching, .foam:  return duration * 2
        case .massage, .sauna, .ice:         return duration * 1
        case .complete:                      return nil
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

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case createdAt, updatedAt, tags
        case restType, suggestedActivities
        case suggestedDurationMinutes, targetAreas
        case recoveryNotes, source, globalActivityId
        case shareable, clubId, creator
    }

    // MARK: - Computed Properties

    public var isPassiveRest: Bool { restType == .complete }

    public var requiresActivity: Bool {
        switch restType {
        case .complete, .massage, .sauna, .ice: return false
        case .active, .mobility, .stretching, .foam: return true
        }
    }

    public var restTypeDescription: String {
        switch restType {
        case .complete:   return "Descanso total. Tu cuerpo necesita recuperarse completamente."
        case .active:     return "Actividad ligera como caminar, nadar suave o yoga restaurativo."
        case .mobility:   return "Trabajo de movilidad articular y flexibilidad."
        case .stretching: return "Sesión de estiramientos estáticos y dinámicos."
        case .foam:       return "Auto-masaje con foam roller para liberar tensiones."
        case .massage:    return "Masaje terapéutico o deportivo profesional."
        case .sauna:      return "Terapia de calor para relajación muscular."
        case .ice:        return "Crioterapia o baño de hielo para recuperación."
        }
    }

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
            "activityTypeKey": "rest",
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "tags": tags,
            "restType": restType.rawValue,
            "source": source.rawValue,
            "shareable": shareable
        ]

        if let description = description { dict["description"] = description }
        if let suggestedActivities = suggestedActivities { dict["suggestedActivities"] = suggestedActivities }
        if let suggestedDurationMinutes = suggestedDurationMinutes { dict["suggestedDurationMinutes"] = suggestedDurationMinutes }
        if let targetAreas = targetAreas { dict["targetAreas"] = targetAreas.map { $0.rawValue } }
        if let recoveryNotes = recoveryNotes { dict["recoveryNotes"] = recoveryNotes }
        if let globalActivityId = globalActivityId { dict["globalActivityId"] = globalActivityId }
        if let clubId = clubId { dict["clubId"] = clubId }
        if let creator = creator { dict["creator"] = creator }

        return dict
    }
}

// MARK: - RestType

public enum RestType: String, Codable, CaseIterable {
    case complete   = "Descanso completo"
    case active     = "Descanso activo"
    case mobility   = "Movilidad"
    case stretching = "Estiramientos"
    case foam       = "Foam rolling"
    case massage    = "Masaje"
    case sauna      = "Sauna"
    case ice        = "Baño de hielo"

    public var shortDescription: String {
        switch self {
        case .complete:   return "Sin actividad"
        case .active:     return "Actividad ligera"
        case .mobility:   return "Movilidad articular"
        case .stretching: return "Estiramientos"
        case .foam:       return "Auto-masaje"
        case .massage:    return "Masaje profesional"
        case .sauna:      return "Terapia de calor"
        case .ice:        return "Crioterapia"
        }
    }

    public var defaultDuration: Int? {
        switch self {
        case .complete:   return nil
        case .active:     return 30
        case .mobility:   return 20
        case .stretching: return 15
        case .foam:       return 15
        case .massage:    return 60
        case .sauna:      return 20
        case .ice:        return 10
        }
    }
}

// MARK: - BodyArea

public enum BodyArea: String, Codable, CaseIterable {
    case fullBody   = "Cuerpo completo"
    case upperBody  = "Tren superior"
    case lowerBody  = "Tren inferior"
    case back       = "Espalda"
    case shoulders  = "Hombros"
    case arms       = "Brazos"
    case core       = "Core"
    case hips       = "Caderas"
    case legs       = "Piernas"
    case calves     = "Pantorrillas"
    case glutes     = "Glúteos"
    case hamstrings = "Isquiotibiales"
    case quads      = "Cuádriceps"
    case chest      = "Pecho"
    case neck       = "Cuello"

    public var icon: String {
        switch self {
        case .fullBody:   return "figure.stand"
        case .upperBody:  return "figure.arms.open"
        case .lowerBody:  return "figure.walk"
        case .back:       return "figure.strengthtraining.traditional"
        case .shoulders:  return "figure.arms.open"
        case .arms:       return "figure.strengthtraining.functional"
        case .core:       return "figure.core.training"
        case .hips:       return "figure.flexibility"
        case .legs:       return "figure.walk"
        case .calves:     return "figure.run"
        case .glutes:     return "figure.strengthtraining.traditional"
        case .hamstrings: return "figure.run"
        case .quads:      return "figure.strengthtraining.traditional"
        case .chest:      return "heart.fill"
        case .neck:       return "figure.mind.and.body"
        }
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension RestActivity {
    public static var completeRest: RestActivity {
        RestActivity(
            name: "Día de Descanso Total",
            description: "Recuperación completa sin actividad física",
            restType: .complete,
            recoveryNotes: "Enfócate en dormir bien y mantener buena hidratación",
            source: .global
        )
    }

    public static var activeRest: RestActivity {
        RestActivity(
            name: "Descanso Activo",
            description: "Caminata ligera y estiramientos",
            restType: .active,
            suggestedActivities: ["Caminata de 20-30 minutos", "Estiramientos suaves", "Yoga restaurativo"],
            suggestedDurationMinutes: 30,
            source: .global
        )
    }

    public static var mobilitySession: RestActivity {
        RestActivity(
            name: "Sesión de Movilidad",
            description: "Trabajo de movilidad articular completo",
            restType: .mobility,
            suggestedActivities: ["Círculos de cadera", "Rotaciones de hombros", "Movilidad de tobillo"],
            suggestedDurationMinutes: 20,
            targetAreas: [.hips, .shoulders, .back],
            source: .global
        )
    }

    public static var example: RestActivity { activeRest }
}
#endif
