
import Foundation
import FirebaseFirestore

// MARK: - GymActivity

public struct GymActivity : Activity {
    
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
        .gym
    }
    
    // MARK: - UI Properties
    
    public var icon: String {
        category?.lowercased().contains("cardio") ?? false
            ? "figure.run"
            : "dumbbell.fill"
    }
    
    public var colorHex: String {
        "3B82F6" // Azul para gym
    }
    
    // MARK: - Gym-Specific Properties
    
    /// Sets de ejercicios que componen la rutina
    public var sets: [RoutineSet]
    
    /// Categoría específica de la rutina (ej: "Full Body", "Upper Body")
    public var category: String?
    
    /// Duración estimada en minutos
    public var estimatedDurationMinutes: Int?
    
    /// Grupo muscular principal afectado
    public var muscularGroupAffected: String?
    
    /// Lista de músculos trabajados
    public var musclesWorked: [String]?
    
    /// Calorías estimadas
    public var estimatedCaloriesValue: Int?
    
    /// Indica si es una rutina premium
    public var isPremiumRoutine: Bool
    
    // MARK: - Activity Protocol Computed Properties
    
    public var estimatedDuration: Int? {
        estimatedDurationMinutes
    }
    
    public var estimatedCalories: Int? {
        estimatedCaloriesValue
    }
    
    // MARK: - Init
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sets: [RoutineSet] = [],
        tags: [String] = [],
        category: String? = nil,
        estimatedDurationMinutes: Int? = nil,
        creator: String? = nil,
        muscularGroupAffected: String? = nil,
        musclesWorked: [String]? = [],
        estimatedCalories: Int? = nil,
        source: ActivitySource = .created,
        globalActivityId: String? = nil,
        shareable: Bool = false,
        clubId: String? = nil,
        isPremiumRoutine: Bool = false
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
        self.creator = creator
        self.muscularGroupAffected = muscularGroupAffected
        self.musclesWorked = musclesWorked
        self.estimatedCaloriesValue = estimatedCalories
        self.source = source
        self.globalActivityId = globalActivityId
        self.shareable = shareable
        self.clubId = clubId
        self.isPremiumRoutine = isPremiumRoutine
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdAt
        case updatedAt
        case sets
        case tags
        case category
        case estimatedDurationMinutes
        case creator
        case muscularGroupAffected
        case musclesWorked
        case estimatedCaloriesValue = "estimatedCalories"
        case source
        case globalActivityId
        case shareable
        case clubId
        case isPremiumRoutine
    }
    
    // MARK: - Computed Properties (Específicos de Gym)
    
    /// Volumen total estimado en kg
    public var estimatedVolumeKg: Double {
        sets.reduce(0) { $0 + $1.estimatedVolumeKg }
    }
    
    /// Total de series en la rutina
    public var totalSeriesCount: Int {
        sets.reduce(0) { $0 + $1.series.count }
    }
    
    /// Total de repeticiones
    public var totalReps: Int {
        sets.reduce(0) { $0 + $1.totalReps }
    }
    
    /// Volumen formateado para UI
    public var formattedVolume: String {
        NumberFormatter.localizedString(
            from: NSNumber(value: estimatedVolumeKg),
            number: .decimal
        ) + " kg"
    }
    
    /// Fecha formateada
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: createdAt)
    }
    
    /// Indica si la rutina es del día actual
    public var isToday: Bool {
        Calendar.current.isDateInToday(createdAt)
    }
    
    /// Días desde la creación
    public var daysOld: Int {
        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }
    
    // MARK: - Activity Protocol: Firestore Serialization
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "activityType": activityType.rawValue,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "sets": sets.map { $0.toDictionary() },
            "tags": tags,
            "source": source.rawValue,
            "shareable": shareable,
            "isPremiumRoutine": isPremiumRoutine
        ]
        
        if let description = description {
            dict["description"] = description
        }
        
        if let category = category {
            dict["category"] = category
        }
        
        if let estimatedDurationMinutes = estimatedDurationMinutes {
            dict["estimatedDurationMinutes"] = estimatedDurationMinutes
        }
        
        if let creator = creator {
            dict["creator"] = creator
        }
        
        if let muscularGroupAffected = muscularGroupAffected {
            dict["muscularGroupAffected"] = muscularGroupAffected
        }
        
        if let musclesWorked = musclesWorked {
            dict["musclesWorked"] = musclesWorked
        }
        
        if let estimatedCaloriesValue = estimatedCaloriesValue {
            dict["estimatedCalories"] = estimatedCaloriesValue
        }
        
        if let globalActivityId = globalActivityId {
            dict["globalActivityId"] = globalActivityId
        }
        
        if let clubId = clubId {
            dict["clubId"] = clubId
        }
        
        return dict
    }
}
