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
    public var categoryName: String {
        category ?? "Sin categoría"
    }
    
    /// Nombre de equipo o valor por defecto
    public var equipmentName: String {
        equipment ?? "Sin equipo"
    }
}



// MARK: - Category (Library)
public struct Category: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var description: String?
    public var iconName: String?
    public var thumbnailURL: URL?

    // MARK: - Init
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        iconName: String? = nil,
        thumbnailURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.thumbnailURL = thumbnailURL
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case iconName
        case thumbnailURL
    }
    
    // MARK: - Firestore Helper
    
    /// Convierte el Category a un diccionario para Firestore
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name
        ]
        
        if let description = description {
            dict["description"] = description
        }
        
        if let iconName = iconName {
            dict["iconName"] = iconName
        }
        
        if let thumbnailURL = thumbnailURL {
            dict["thumbnailURL"] = thumbnailURL.absoluteString
        }
        
        return dict
    }
    
    // MARK: - Computed Properties
    
    /// Descripción legible o valor por defecto
    public var descriptionText: String {
        description ?? "Sin descripción"
    }
    
    /// Verifica si tiene imagen
    public var hasImage: Bool {
        thumbnailURL != nil
    }
}



public struct CategoryDataset {
    public static let all: [Category] = [
        Category(
            name: "Fuerza",
            description: "Ejercicios enfocados en aumentar la masa muscular y la fuerza corporal.",
            iconName: "dumbbell.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/strength.jpg")
        ),
        Category(
            name: "Cardio",
            description: "Actividades que mejoran la resistencia cardiovascular y queman calorías.",
            iconName: "heart.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/cardio.jpg")
        ),
        Category(
            name: "Movilidad",
            description: "Rutinas para mejorar la flexibilidad, la movilidad articular y la postura.",
            iconName: "figure.walk",
            thumbnailURL: URL(string: "https://example.com/images/categories/mobility.jpg")
        ),
        Category(
            name: "Core",
            description: "Ejercicios para fortalecer el abdomen, la espalda baja y el equilibrio corporal.",
            iconName: "circle.hexagonpath.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/core.jpg")
        ),
        Category(
            name: "Piernas",
            description: "Entrenamientos centrados en glúteos, cuádriceps, femorales y pantorrillas.",
            iconName: "figure.run",
            thumbnailURL: URL(string: "https://example.com/images/categories/legs.jpg")
        ),
        Category(
            name: "Brazos",
            description: "Ejercicios para desarrollar bíceps, tríceps y antebrazos.",
            iconName: "hand.raised.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/arms.jpg")
        ),
        Category(
            name: "Espalda",
            description: "Movimientos para fortalecer la espalda alta, media y baja.",
            iconName: "rectangle.stack.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/back.jpg")
        ),
        Category(
            name: "Pecho",
            description: "Entrenamientos dirigidos al desarrollo de los músculos pectorales.",
            iconName: "square.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/chest.jpg")
        ),
        Category(
            name: "Yoga",
            description: "Prácticas de respiración, estiramiento y equilibrio mente-cuerpo.",
            iconName: "figure.yoga",
            thumbnailURL: URL(string: "https://example.com/images/categories/yoga.jpg")
        ),
        Category(
            name: "HIIT",
            description: "Entrenamientos de alta intensidad por intervalos, ideales para quemar grasa.",
            iconName: "flame.fill",
            thumbnailURL: URL(string: "https://example.com/images/categories/hiit.jpg")
        )
    ]
}

