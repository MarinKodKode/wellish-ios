import Foundation

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
    public var creator: String?
    public var tags: [String]
    public var thumbnailURL: String?
    public var notes: String?
    
    // MARK: - Plan Configuration
    public var goal: PlanGoal
    public var durationWeeks: Int
    public var startDate: Date?
    public var activitiesPerWeek: Int
    
    // MARK: - Premium & Sharing
    public var shareable: Bool
    public var isPremiumPlan: Bool
    public var isBeingTracked : Bool
    
    // MARK: - Init
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        category: String? = nil,
        creator: String? = nil,
        tags: [String] = [],
        thumbnailURL: String? = nil,
        notes: String? = nil,
        elements: [PlanElement] = [],
        goal: PlanGoal = .general,
        durationWeeks: Int = 4,
        startDate: Date? = nil,
        activitiesPerWeek: Int = 3,
        shareable: Bool = false,
        isPremiumPlan: Bool = false,
        isBeingTracked : Bool = false
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
        self.isBeingTracked = isBeingTracked
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name, createdAt, updatedAt, elements
        case description, category, creator, tags, thumbnailURL, notes
        case goal, durationWeeks, startDate, activitiesPerWeek
        case shareable, isPremiumPlan, isBeingTracked
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
            dict["thumbnailURL"] = thumbnailURL
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
    
    public func upcomingActivity() -> PlanElement? {
        return elements.first{ $0.completed == false}
    }
}
