//
//  ActivityFirestoreService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ActivityFirestoreService {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    
    /// Colección global de activities (templates, club content, premium)
    private let globalCollection = "globalActivities"
    
    // MARK: - Helper: User Activities Path
    
    /// Obtiene la referencia a la colección de activities del usuario
    private func userActivitiesCollection(userId: String) -> CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("user-activities")
    }
    
    /// Obtiene el userId actual
    private func getCurrentUserId() throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirestoreError.notAuthenticated
        }
        return userId
    }
    
    // MARK: - CREATE (Upload Activities)
    
    /// Sube una nueva actividad a la colección personal del usuario (genera ID automático)
    @MainActor
    func uploadActivity(_ activity: ActivityType) async throws -> String {
        let userId = try getCurrentUserId()
        
        let docRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)
        
        return docRef.documentID
    }
    
    /// Sube una actividad con ID específico (mantiene el ID del modelo)
    @MainActor
    func uploadActivityWithID(_ activity: ActivityType) async throws {
        let userId = try getCurrentUserId()
        
        try userActivitiesCollection(userId: userId)
            .document(activity.id)
            .setData(from: activity)
    }
    
    /// Sube múltiples actividades
    @MainActor
    func uploadActivities(_ activities: [ActivityType]) async throws {
        for activity in activities {
            try await uploadActivityWithID(activity)
        }
    }
    
    // MARK: - READ (Fetch Activities)
    
    /// Obtiene todas las actividades del usuario actual
    @MainActor
    func fetchUserActivities() async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        
        let snapshot = try await userActivitiesCollection(userId: userId)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
        return activities
    }
    
    /// Obtiene actividades del usuario filtradas por categoría
    @MainActor
    func fetchUserActivities(category: ActivityCategory) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
        
        return activities
    }
    
    /// Obtiene una actividad específica por ID
    @MainActor
    func fetchActivity(id: String) async throws -> ActivityType {
        let userId = try getCurrentUserId()
        
        let document = try await userActivitiesCollection(userId: userId)
            .document(id)
            .getDocument()
        
        guard document.exists else {
            throw FirestoreError.activityNotFound(id)
        }
        
        let activity = try document.data(as: ActivityType.self)
        return activity
    }
    
    // MARK: - UPDATE
    
    /// Actualiza una actividad existente
    @MainActor
    func updateActivity(_ activity: ActivityType) async throws {
        let userId = try getCurrentUserId()
        
        // Actualizar fecha de modificación
        var updatedActivity = activity
        // Nota: Necesitarías hacer esto en cada modelo específico
        // Por ahora, simplemente sobrescribe
        
        try userActivitiesCollection(userId: userId)
            .document(activity.id)
            .setData(from: updatedActivity, merge: true)
    }
    
    // MARK: - DELETE
    
    /// Elimina una actividad
    @MainActor
    func deleteActivity(id: String) async throws {
        let userId = try getCurrentUserId()
        
        try await userActivitiesCollection(userId: userId)
            .document(id)
            .delete()
        
    }
    
    /// Elimina múltiples actividades
    @MainActor
    func deleteActivities(ids: [String]) async throws {
        for id in ids {
            try await deleteActivity(id: id)
        }
    }
    
    // MARK: - QUERIES (User Activities)
    
    /// Obtiene actividades por fuente
    @MainActor
    func fetchUserActivities(bySource source: ActivitySource) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("source", isEqualTo: source.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
    }
    
    /// Obtiene actividades compartibles del usuario
    @MainActor
    func fetchUserShareableActivities() async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("shareable", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
    }
    
    /// Obtiene actividades por tags
    @MainActor
    func fetchUserActivities(withTag tag: String) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("tags", arrayContains: tag)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
    }
    
    // MARK: - GLOBAL ACTIVITIES (Templates, Club Content)
    
    /// Obtiene templates globales
    @MainActor
    func fetchGlobalTemplates() async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.template.rawValue)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
        
        return activities
    }
    
    /// Obtiene templates globales por categoría
    @MainActor
    func fetchGlobalTemplates(category: ActivityCategory) async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.template.rawValue)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
    }
    
    /// Obtiene contenido de un club específico
    @MainActor
    func fetchClubActivities(clubId: String) async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("clubId", isEqualTo: clubId)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
    }
    
    /// Copia un template global a la colección personal del usuario
    @MainActor
    func copyTemplateToUser(templateId: String) async throws -> String {
        let userId = try getCurrentUserId()
        
        // 1. Obtener template de globalActivities
        let templateDoc = try await db.collection(globalCollection)
            .document(templateId)
            .getDocument()
        
        guard templateDoc.exists else {
            throw FirestoreError.templateNotFound(templateId)
        }
        
        var activity = try templateDoc.data(as: ActivityType.self)
        
        // 2. Modificar metadata para usuario
        // Aquí necesitarías una forma de modificar el ActivityType
        // Por simplicidad, lo dejamos como está y cambiamos el source
        
        // 3. Guardar en colección personal
        let newDocRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)
        
        return newDocRef.documentID
    }
    
    // MARK: - SHARING (Community Activities)
    
    /// Genera código de compartir para una actividad
    @MainActor
    func generateShareCode(activityId: String) async throws -> String {
        let userId = try getCurrentUserId()
        
        // Verificar que la actividad sea compartible
        let activity = try await fetchActivity(id: activityId)
        
        guard activity.shareable else {
            throw FirestoreError.activityNotShareable
        }
        
        // Generar código único (6 caracteres alfanuméricos)
        let code = generateRandomCode()
        
        // Guardar referencia en colección de códigos compartidos
        try await db.collection("sharedActivities")
            .document(code)
            .setData([
                "userId": userId,
                "activityId": activityId,
                "createdAt": FieldValue.serverTimestamp(),
                "expiresAt": Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
            ])
        
        return code
    }
    
    /// Importa una actividad usando código de compartir
    @MainActor
    func importActivityFromCode(_ code: String) async throws -> String {
        let userId = try getCurrentUserId()
        
        // 1. Obtener referencia desde código
        let codeDoc = try await db.collection("sharedActivities")
            .document(code)
            .getDocument()
        
        guard codeDoc.exists,
              let data = codeDoc.data(),
              let ownerId = data["userId"] as? String,
              let activityId = data["activityId"] as? String else {
            throw FirestoreError.invalidShareCode
        }
        
        // 2. Obtener actividad del dueño
        let activityDoc = try await db.collection("users")
            .document(ownerId)
            .collection("activities")
            .document(activityId)
            .getDocument()
        
        guard activityDoc.exists else {
            throw FirestoreError.activityNotFound(activityId)
        }
        
        var activity = try activityDoc.data(as: ActivityType.self)
        
        // 3. Copiar a colección personal (cambiar source a community)
        let newDocRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)
        
        return newDocRef.documentID
    }
    
//    // MARK: - REALTIME LISTENERS
//    
//    /// Escucha cambios en las actividades del usuario en tiempo real
//    @MainActor
//    func listenToUserActivities(
//        completion: @escaping (Result<[ActivityType], Error>) -> Void
//    ) -> ListenerRegistration {
//        
//        guard let userId = try? getCurrentUserId() else {
//            completion(.failure(FirestoreError.notAuthenticated))
//            return ListenerRegistration() // Dummy
//        }
//        
//        return userActivitiesCollection(userId: userId)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                let activities = snapshot?.documents.compactMap { doc -> ActivityType? in
//                    try? doc.data(as: ActivityType.self)
//                } ?? []
//                
//                completion(.success(activities))
//                print("🔄 Activities updated: \(activities.count)")
//            }
//    }
    
//    /// Escucha cambios en una actividad específica
//    @MainActor
//    func listenToActivity(
//        id: String,
//        completion: @escaping (Result<ActivityType, Error>) -> Void
//    ) -> ListenerRegistration {
//        
//        guard let userId = try? getCurrentUserId() else {
//            completion(.failure(FirestoreError.notAuthenticated))
//            return ListenerRegistration() // Dummy
//        }
//        
//        return userActivitiesCollection(userId: userId)
//            .document(id)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let snapshot = snapshot, snapshot.exists else {
//                    completion(.failure(FirestoreError.activityNotFound(id)))
//                    return
//                }
//                
//                do {
//                    let activity = try snapshot.data(as: ActivityType.self)
//                    completion(.success(activity))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//    }
//    
    // MARK: - BATCH OPERATIONS
    
    /// Sube múltiples actividades en batch (más eficiente)
    @MainActor
    func uploadActivitiesBatch(_ activities: [ActivityType]) async throws {
        let userId = try getCurrentUserId()
        let batch = db.batch()
        
        for activity in activities {
            let docRef = userActivitiesCollection(userId: userId)
                .document(activity.id)
            
            try batch.setData(from: activity, forDocument: docRef)
        }
        
        try await batch.commit()
    }
    
    // MARK: - HELPERS
    
    /// Genera código aleatorio de 6 caracteres
    private func generateRandomCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
}

// MARK: - Errors

enum FirestoreError: LocalizedError {
    case notAuthenticated
    case activityNotFound(String)
    case templateNotFound(String)
    case activityNotShareable
    case invalidShareCode
    case clubAccessDenied
    case premiumRequired
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Usuario no autenticado"
        case .activityNotFound(let id):
            return "Actividad no encontrada: \(id)"
        case .templateNotFound(let id):
            return "Template no encontrado: \(id)"
        case .activityNotShareable:
            return "Esta actividad no se puede compartir. Activa la opción premium."
        case .invalidShareCode:
            return "Código de compartir inválido o expirado"
        case .clubAccessDenied:
            return "No tienes acceso a este contenido de club"
        case .premiumRequired:
            return "Esta función requiere suscripción premium"
        }
    }
}

// MARK: - Migration Helper

extension ActivityFirestoreService {
    
    /// Migra rutinas antiguas (de /routines) al nuevo formato (users/{userId}/activities)
    @MainActor
    func migrateRoutinesFromOldStructure() async throws {
        let userId = try getCurrentUserId()
        
        // 1. Obtener rutinas antiguas de /routines donde creator == userId
        let oldSnapshot = try await db.collection("routines")
            .whereField("creator", isEqualTo: userId)
            .getDocuments()
        
        print("🔄 Migrando \(oldSnapshot.documents.count) rutinas antiguas...")
        
        var migratedCount = 0
        
        for doc in oldSnapshot.documents {
            do {
                let gymActivity = try doc.data(as: GymActivity.self)
                let activityType = ActivityType.gym(gymActivity)
                
                // Subir a nueva ubicación
                try await uploadActivityWithID(activityType)
                
                // Opcional: eliminar de ubicación antigua
                // try await doc.reference.delete()
                
                migratedCount += 1
            } catch {
                print("⚠️ Error migrando rutina \(doc.documentID): \(error.localizedDescription)")
            }
        }
        
        print("✅ Migración completada: \(migratedCount) rutinas migradas")
    }
}

// MARK: - Statistics

extension ActivityFirestoreService {
    
    /// Obtiene estadísticas de las actividades del usuario
    @MainActor
    func getUserStatistics() async throws -> ActivityFirestoreStatistics {
        let activities = try await fetchUserActivities()
        
        var categoryCounts: [ActivityCategory: Int] = [:]
        var sourceCounts: [ActivitySource: Int] = [:]
        
        for activity in activities {
            categoryCounts[activity.category, default: 0] += 1
            sourceCounts[activity.source, default: 0] += 1
        }
        
        let totalDuration = activities.compactMap { $0.estimatedDuration }.reduce(0, +)
        let totalCalories = activities.compactMap { $0.estimatedCalories }.reduce(0, +)
        
        return ActivityFirestoreStatistics(
            totalActivities: activities.count,
            categoryCounts: categoryCounts,
            sourceCounts: sourceCounts,
            totalEstimatedDuration: totalDuration,
            totalEstimatedCalories: totalCalories,
            shareableCount: activities.filter { $0.shareable }.count
        )
    }
}

struct ActivityFirestoreStatistics {
    let totalActivities: Int
    let categoryCounts: [ActivityCategory: Int]
    let sourceCounts: [ActivitySource: Int]
    let totalEstimatedDuration: Int
    let totalEstimatedCalories: Int
    let shareableCount: Int
    
    var formattedDuration: String {
        let hours = totalEstimatedDuration / 60
        let minutes = totalEstimatedDuration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes) min"
        }
    }
    
    var formattedCalories: String {
        "\(totalEstimatedCalories) kcal"
    }
}
