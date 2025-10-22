import Foundation

// MARK: - Plan (Workout Plan)
public struct Plan: Identifiable, Codable, Hashable {
    
    // MARK: - Required Properties
    public let id: String
    public var name: String
    public var createdAt: Date
    public var updatedAt: Date
    public var elements: [PlanElement]
    
    // MARK: - Optional Properties
    public var description: String?
    public var category: String?
    public var creator: String? // Firebase Auth UID
    public var tags: [String]
    public var thumbnailURL: URL?
    public var notes: String?
    
    // MARK: - Plan Configuration
    public var goal: PlanGoal
    public var durationWeeks: Int
    public var startDate: Date?
    public var activitiesPerWeek: Int
    
    // MARK: - Premium & Sharing
    public var shareable: Bool
    public var isPremiumPlan: Bool
    
    // MARK: - Init
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        category: String? = nil,
        creator: String? = nil,
        tags: [String] = [],
        thumbnailURL: URL? = nil,
        notes: String? = nil,
        elements: [PlanElement] = [],
        goal: PlanGoal = .general,
        durationWeeks: Int = 4,
        startDate: Date? = nil,
        activitiesPerWeek: Int = 3,
        shareable: Bool = false,
        isPremiumPlan: Bool = false
    ) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.updatedAt = Date()
        self.description = description
        self.category = category
        self.creator = creator
        self.tags = tags
        self.thumbnailURL = thumbnailURL
        self.notes = notes
        self.elements = elements
        self.goal = goal
        self.durationWeeks = durationWeeks
        self.startDate = startDate
        self.activitiesPerWeek = activitiesPerWeek
        self.shareable = shareable
        self.isPremiumPlan = isPremiumPlan
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name, createdAt, updatedAt, elements
        case description, category, creator, tags, thumbnailURL, notes
        case goal, durationWeeks, startDate, activitiesPerWeek
        case shareable, isPremiumPlan
    }
    
    // MARK: - Firestore Helper
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "createdAt": createdAt,
            "updatedAt": updatedAt,
            "elements": elements.map { $0.toDictionary() },
            "tags": tags,
            "goal": goal.rawValue,
            "durationWeeks": durationWeeks,
            "activitiesPerWeek": activitiesPerWeek,
            "shareable": shareable,
            "isPremiumPlan": isPremiumPlan
        ]
        
        if let description = description {
            dict["description"] = description
        }
        
        if let category = category {
            dict["category"] = category
        }
        
        if let creator = creator {
            dict["creator"] = creator
        }
        
        if let thumbnailURL = thumbnailURL {
            dict["thumbnailURL"] = thumbnailURL.absoluteString
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        if let startDate = startDate {
            dict["startDate"] = startDate
        }
        
        return dict
    }
    
    // MARK: - Computed Properties
    
    /// Fecha de finalización estimada del plan
    public var endDate: Date? {
        guard let startDate = startDate else { return nil }
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: durationWeeks, to: startDate)
    }
    
    /// Total de actividades en el plan
    public var totalActivities: Int {
        elements.count
    }
    
    /// Actividades completadas
    public var completedActivities: Int {
        elements.filter { $0.completed }.count
    }
    
    /// Porcentaje de completación (0-100)
    public var completionPercentage: Double {
        guard totalActivities > 0 else { return 0 }
        return (Double(completedActivities) / Double(totalActivities)) * 100
    }
    
    /// Plan completado
    public var isCompleted: Bool {
        !elements.isEmpty && elements.allSatisfy { $0.completed }
    }
    
    /// Plan activo (tiene fecha de inicio y no ha terminado)
    public var isActive: Bool {
        guard let startDate = startDate,
              let endDate = endDate else { return false }
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    /// Días restantes del plan
    public var daysRemaining: Int? {
        guard let endDate = endDate else { return nil }
        let calendar = Calendar.current
        let now = Date()
        guard now < endDate else { return 0 }
        return calendar.dateComponents([.day], from: now, to: endDate).day
    }
    
    /// Semana actual del plan (basado en startDate)
    public var currentWeek: Int? {
        guard let startDate = startDate else { return nil }
        let calendar = Calendar.current
        let now = Date()
        guard now >= startDate else { return nil }
        let weeks = calendar.dateComponents([.weekOfYear], from: startDate, to: now).weekOfYear ?? 0
        return min(weeks + 1, durationWeeks)
    }
    
    /// Formato legible de duración
    public var formattedDuration: String {
        if durationWeeks == 1 {
            return "1 semana"
        } else {
            return "\(durationWeeks) semanas"
        }
    }
    
    /// Formato de progreso
    public var progressText: String {
        "\(completedActivities)/\(totalActivities) completadas"
    }
    
    /// Tiene imagen
    public var hasImage: Bool {
        thumbnailURL != nil
    }
    
    /// Nombre de categoría o valor por defecto
    public var categoryName: String {
        category ?? "Sin categoría"
    }
    
    /// Días totales del plan
    public var totalDays: Int {
        durationWeeks * 7
    }
    
    // MARK: - Methods
    
    /// Agregar elemento al plan
    public mutating func addElement(_ element: PlanElement) {
        elements.append(element)
        updatedAt = Date()
    }
    
    /// Eliminar elemento en índice
    public mutating func removeElement(at index: Int) {
        guard index >= 0 && index < elements.count else { return }
        elements.remove(at: index)
        updatedAt = Date()
    }
    
    /// Eliminar elemento por ID
    public mutating func removeElement(id: String) {
        elements.removeAll { $0.id == id }
        updatedAt = Date()
    }
    
    /// Marcar elemento como completado
    public mutating func markElementCompleted(at index: Int, completed: Bool = true) {
        guard index >= 0 && index < elements.count else { return }
        elements[index].completed = completed
        if completed {
            elements[index].completedAt = Date()
        } else {
            elements[index].completedAt = nil
        }
        updatedAt = Date()
    }
    
    /// Marcar elemento como completado por ID
    public mutating func markElementCompleted(id: String, completed: Bool = true) {
        guard let index = elements.firstIndex(where: { $0.id == id }) else { return }
        markElementCompleted(at: index, completed: completed)
    }
    
    /// Iniciar el plan (establece startDate)
    public mutating func start() {
        startDate = Date()
        updatedAt = Date()
    }
    
    /// Reiniciar progreso del plan
    public mutating func resetProgress() {
        for i in 0..<elements.count {
            elements[i].completed = false
            elements[i].completedAt = nil
        }
        updatedAt = Date()
    }
    
    /// Obtener elementos de un día específico
    public func elements(forDay day: Int) -> [PlanElement] {
        elements.filter { $0.day == day }
    }
    
    /// Obtener actividad de hoy (basado en startDate)
    public func todaysActivities() -> [PlanElement] {
        guard let startDate = startDate else { return [] }
        let calendar = Calendar.current
        let daysPassed = calendar.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        let currentDay = (daysPassed % totalDays) + 1
        return elements(forDay: currentDay)
    }
}

// MARK: - PlanElement (Activity in Plan)
public struct PlanElement: Identifiable, Codable, Hashable {
    
    // MARK: - Required Properties
    public let id: String
    public var activity: Exercise // ✅ Exercise como abstracción universal
    public var day: Int // Día del plan (1, 2, 3... N)
    public var completed: Bool
    
    // MARK: - Optional Properties
    public var completedAt: Date?
    public var notes: String?
    public var scheduledTime: Date? // Hora sugerida (solo hora/minuto)
    
    // MARK: - Performance Data (para cuando se completa)
    public var actualDurationMinutes: Int? // Duración real
    public var actualDistanceKm: Double? // Distancia real (si aplica)
    public var actualCalories: Int? // Calorías quemadas (si aplica)
    public var performanceNotes: String? // Notas de la sesión
    public var rpe: Int? // Rate of Perceived Exertion (1-10)
    
    // MARK: - Init
    public init(
        id: String = UUID().uuidString,
        activity: Exercise,
        day: Int,
        completed: Bool = false,
        completedAt: Date? = nil,
        notes: String? = nil,
        scheduledTime: Date? = nil,
        actualDurationMinutes: Int? = nil,
        actualDistanceKm: Double? = nil,
        actualCalories: Int? = nil,
        performanceNotes: String? = nil,
        rpe: Int? = nil
    ) {
        self.id = id
        self.activity = activity
        self.day = day
        self.completed = completed
        self.completedAt = completedAt
        self.notes = notes
        self.scheduledTime = scheduledTime
        self.actualDurationMinutes = actualDurationMinutes
        self.actualDistanceKm = actualDistanceKm
        self.actualCalories = actualCalories
        self.performanceNotes = performanceNotes
        self.rpe = rpe
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, activity, day, completed
        case completedAt, notes, scheduledTime
        case actualDurationMinutes, actualDistanceKm, actualCalories
        case performanceNotes, rpe
    }
    
    // MARK: - Firestore Helper
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "activity": activity.toDictionary(),
            "day": day,
            "completed": completed
        ]
        
        if let completedAt = completedAt {
            dict["completedAt"] = completedAt
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        if let scheduledTime = scheduledTime {
            dict["scheduledTime"] = scheduledTime
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
        
        if let performanceNotes = performanceNotes {
            dict["performanceNotes"] = performanceNotes
        }
        
        if let rpe = rpe {
            dict["rpe"] = rpe
        }
        
        return dict
    }
    
    // MARK: - Computed Properties
    
    /// Nombre a mostrar de la actividad
    public var displayName: String {
        activity.name
    }
    
    /// Descripción de la actividad (de Exercise)
    public var activityDescription: String {
        var parts: [String] = []
        
        // Usar categoría del Exercise
        if let category = activity.category {
            parts.append(category)
        }
        
        // Si tiene equipo
        if let equipment = activity.equipment {
            parts.append(equipment)
        }
        
        return parts.isEmpty ? "" : parts.joined(separator: " · ")
    }
    
    /// Músculos trabajados (de Exercise)
    public var musclesWorked: [String] {
        activity.muscles
    }
    
    /// Icono del ejercicio (puedes usar SF Symbol o emoji según categoría)
    public var icon: String {
        // Lógica básica basada en categoría
        guard let category = activity.category?.lowercased() else {
            return "figure.walk"
        }
        
        if category.contains("cardio") || category.contains("correr") {
            return "figure.run"
        } else if category.contains("nadar") || category.contains("natación") {
            return "figure.pool.swim"
        } else if category.contains("bici") || category.contains("ciclismo") {
            return "bicycle"
        } else if category.contains("yoga") || category.contains("pilates") {
            return "figure.mind.and.body"
        } else if category.contains("descanso") || category.contains("rest") {
            return "bed.double.fill"
        } else {
            return "dumbbell.fill"
        }
    }
    
    /// Hora formateada
    public var formattedTime: String? {
        guard let scheduledTime = scheduledTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: scheduledTime)
    }
    
    /// Formato de día
    public var formattedDay: String {
        "Día \(day)"
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
    
    // MARK: - Methods
    
    /// Marcar como completado con datos de rendimiento
    public mutating func markCompleted(
        durationMinutes: Int? = nil,
        distanceKm: Double? = nil,
        calories: Int? = nil,
        notes: String? = nil,
        rpe: Int? = nil
    ) {
        self.completed = true
        self.completedAt = Date()
        self.actualDurationMinutes = durationMinutes
        self.actualDistanceKm = distanceKm
        self.actualCalories = calories
        self.performanceNotes = notes
        self.rpe = rpe
    }
    
    /// Resetear completación
    public mutating func resetCompletion() {
        self.completed = false
        self.completedAt = nil
        self.actualDurationMinutes = nil
        self.actualDistanceKm = nil
        self.actualCalories = nil
        self.performanceNotes = nil
        self.rpe = nil
    }
}

// MARK: - PlanGoal Enum
public enum PlanGoal: String, Codable, CaseIterable {
    case hypertrophy = "hypertrophy"
    case strength = "strength"
    case endurance = "endurance"
    case weightLoss = "weight_loss"
    case athletic = "athletic"
    case general = "general"
    case flexibility = "flexibility"
    case rehabilitation = "rehabilitation"
    
    // Nuevos objetivos
    case run5k = "run_5k"
    case run10k = "run_10k"
    case run21k = "run_21k"
    case marathon = "marathon"
    case ironman = "ironman"
    case mountainClimb = "mountain_climb"
    case fatLoss = "fat_loss"
    case mobility = "mobility"
    case wellness = "wellness"
    
    public var displayName: String {
        switch self {
        case .hypertrophy: return "Hipertrofia"
        case .strength: return "Fuerza"
        case .endurance: return "Resistencia"
        case .weightLoss: return "Pérdida de peso"
        case .athletic: return "Rendimiento atlético"
        case .general: return "Fitness general"
        case .flexibility: return "Flexibilidad"
        case .rehabilitation: return "Rehabilitación"
        case .run5k: return "Correr 5K"
        case .run10k: return "Correr 10K"
        case .run21k: return "Correr 21K"
        case .marathon: return "Correr maratón"
        case .ironman: return "Completar Ironman"
        case .mountainClimb: return "Subir montaña"
        case .fatLoss: return "Pérdida de grasa"
        case .mobility: return "Movilidad"
        case .wellness: return "Bienestar general"
        }
    }
    
    public var icon: String {
        switch self {
        case .hypertrophy: return "figure.strengthtraining.traditional"
        case .strength: return "flame.fill"
        case .endurance: return "heart.fill"
        case .weightLoss: return "chart.line.downtrend.xyaxis"
        case .athletic: return "trophy.fill"
        case .general: return "figure.walk"
        case .flexibility: return "figure.yoga"
        case .rehabilitation: return "cross.case.fill"
        case .run5k, .run10k, .run21k, .marathon: return "figure.run"
        case .ironman: return "bicycle.circle.fill"
        case .mountainClimb: return "mountain.2.fill"
        case .fatLoss: return "scalemass.fill"
        case .mobility: return "figure.cooldown"
        case .wellness: return "leaf.fill"
        }
    }
    
    public var description: String {
        switch self {
        case .hypertrophy:
            return "Aumentar masa muscular y volumen"
        case .strength:
            return "Incrementar fuerza máxima"
        case .endurance:
            return "Mejorar resistencia cardiovascular"
        case .weightLoss:
            return "Reducir grasa corporal"
        case .athletic:
            return "Mejorar rendimiento deportivo"
        case .general:
            return "Mantener forma física general"
        case .flexibility:
            return "Mejorar rango de movimiento"
        case .rehabilitation:
            return "Recuperación de lesiones"
        case .run5k:
            return "Prepararse para correr 5 kilómetros"
        case .run10k:
            return "Prepararse para correr 10 kilómetros"
        case .run21k:
            return "Prepararse para correr una media maratón (21K)"
        case .marathon:
            return "Prepararse para completar una maratón (42K)"
        case .ironman:
            return "Preparación para un triatlón Ironman"
        case .mountainClimb:
            return "Entrenamiento para subir una montaña"
        case .fatLoss:
            return "Reducir porcentaje de grasa corporal"
        case .mobility:
            return "Mejorar movilidad y salud articular"
        case .wellness:
            return "Promover bienestar físico y mental"
        }
    }
    
    public var color: String {
        switch self {
        case .hypertrophy: return "blue"
        case .strength: return "red"
        case .endurance: return "green"
        case .weightLoss: return "orange"
        case .athletic: return "purple"
        case .general: return "gray"
        case .flexibility: return "pink"
        case .rehabilitation: return "mint"
        case .run5k: return "teal"
        case .run10k: return "teal"
        case .run21k: return "cyan"
        case .marathon: return "indigo"
        case .ironman: return "black"
        case .mountainClimb: return "brown"
        case .fatLoss: return "yellow"
        case .mobility: return "lightBlue"
        case .wellness: return "green"
        }
    }
}
