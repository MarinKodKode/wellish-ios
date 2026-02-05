import Foundation

// MARK: - Exercise (Library)
public struct Exercise: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var category: ExerciseCategory?
    public var equipment: String?
    public var muscles: [String]
    public var thumbnailURL: URL?
    
    // --- NUEVAS PROPIEDADES AÑADIDAS (OPCIONALES) ---
    public var videoUrl: URL? // Enlace al video de instrucciones
    public var instructions: String? // Texto detallado de las instrucciones
    // --------------------------------------------------

    public init(
        id: String = UUID().uuidString,
        name: String,
        category: ExerciseCategory? = nil,
        equipment: String? = nil,
        muscles: [String] = [],
        thumbnailURL: URL? = nil,
        // Incluir las nuevas propiedades en el inicializador
        videoUrl: URL? = nil,
        instructions: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.equipment = equipment
        self.muscles = muscles
        self.thumbnailURL = thumbnailURL
        
        // Asignación de nuevas propiedades
        self.videoUrl = videoUrl
        self.instructions = instructions
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case equipment
        case muscles
        case thumbnailURL
        
        // --- Añadir las nuevas propiedades a CodingKeys ---
        case videoUrl
        case instructions
        // ---------------------------------------------------
    }
    
    // MARK: - Firestore Helper
    
    /// Convierte el Exercise a un diccionario para Firestore
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "muscles": muscles
        ]
        
        if let category = category {
            dict["category"] = category
        }
        
        if let equipment = equipment {
            dict["equipment"] = equipment
        }
        
        if let thumbnailURL = thumbnailURL {
            dict["thumbnailURL"] = thumbnailURL.absoluteString
        }
        
        // --- Guardar las nuevas propiedades si existen ---
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl.absoluteString
        }
        
        if let instructions = instructions {
            dict["instructions"] = instructions
        }
        // -------------------------------------------------
        
        return dict
    }
    
    // MARK: - Computed Properties
    
    /// Muestra los músculos en formato legible
    public var musclesDisplay: String {
        muscles.isEmpty ? "—" : muscles.joined(separator: ", ")
    }
    
    /// Verifica si tiene imagen
    public var hasImage: Bool {
        thumbnailURL != nil
    }
    
    /// Nombre de categoría o valor por defecto
    public var categoryName: ExerciseCategory {
        category ?? .strength
    }
    
    /// Nombre de equipo o valor por defecto
    public var equipmentName: String {
        equipment ?? "Sin equipo"
    }
}


public enum ExerciseCategory: String, Codable {
    // Categorías de Gym (Fuerza)
    case strength = "Fuerza" // Nuevo nombre para el grupo de Gimnasio
    case chest = "Pecho"
    case back = "Espalda"
    case legs = "Piernas"
    case shoulders = "Hombros"
    case arms = "Brazos"
    case core = "Core"
    
    // Categorías de Cardio/Funcional
    case hiit = "HIIT"
    case plyometric = "Pliométricos"
    
    //Cardio
    case cardio
}
