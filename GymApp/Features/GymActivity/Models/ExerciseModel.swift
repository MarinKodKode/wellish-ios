//
//  ExerciseModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
//

import Foundation

// MARK: - Exercise (Library)
public struct Exercise: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var category: ExerciseCategory?
    public var equipment: String?
    public var muscles: [String]
    public var thumbnailURL: URL?

    public init(
        id: String = UUID().uuidString,
        name: String,
        category: ExerciseCategory? = nil,
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
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case equipment
        case muscles
        case thumbnailURL
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
