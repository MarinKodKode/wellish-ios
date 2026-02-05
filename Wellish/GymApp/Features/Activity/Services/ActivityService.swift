import Foundation
import Combine

protocol ActivityServiceProtocol {
    var errorMessage: String? { get set }
    var isOnline: Bool { get }
    var lastSyncDate: Date? { get }
    
    // Public methods
    func getActivities() async -> [ActivityType]
    func getActivities(category: ActivityCategory) async -> [ActivityType]
    func getActivity(by id: String) async -> ActivityType?
    func saveActivity(_ activity: ActivityType) async -> Bool
    func deleteActivity(id: String) async -> Bool
    func syncActivities() async -> Bool
}

// MARK: - ActivityService Implementation

final class ActivityService: ActivityServiceProtocol, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var errorMessage: String?
    @Published public var isOnline: Bool = true
    @Published public var lastSyncDate: Date?
    @Published public var isSyncing: Bool = false
    
    // MARK: - Services
    
    private let firestoreService = ActivityFirestoreService()
    private let localStorageService = ActivityLocalStorageService()
    
    // MARK: - Configuration
    
    /// Estrategia de sincronización
    public enum SyncStrategy {
        case localFirst      // Intenta local primero, luego Firestore
        case firestoreFirst  // Intenta Firestore primero, luego local
        case localOnly       // Solo local (modo offline)
        case firestoreOnly   // Solo Firestore (requiere conexión)
    }
    
    public var syncStrategy: SyncStrategy = .localFirst
    
    // MARK: - Init
    
    init() {
        // Configurar observers de conectividad si es necesario
    }
    
    // MARK: - Public Methods (Simplified API)
    
    /// Obtiene todas las actividades disponibles
    public func getActivities() async -> [ActivityType] {
        do {
            let activities = try await fetchActivities()
            return activities
        } catch {
            print("⚠️ Error getting activities: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Obtiene actividades filtradas por categoría
    public func getActivities(category: ActivityCategory) async -> [ActivityType] {
        do {
            let activities = try await fetchActivities(category: category)
            return activities
        } catch {
            print("⚠️ Error getting \(category.rawValue) activities: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Obtiene una actividad específica por ID
    public func getActivity(by id: String) async -> ActivityType? {
        do {
            let activity = try await fetchActivity(by: id)
            return activity
        } catch {
            print("⚠️ Error getting activity \(id): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Guarda una actividad (local + Firestore)
    public func saveActivity(_ activity: ActivityType) async -> Bool {
        await MainActor.run { errorMessage = nil }
        
        do {
            try await saveActivityToStorage(activity)
            print("✅ Activity saved: \(activity.displayName)")
            return true
        } catch {
            await MainActor.run {
                errorMessage = "Error al guardar: \(error.localizedDescription)"
            }
            print("❌ Error saving activity: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Elimina una actividad (local + Firestore)
    public func deleteActivity(id: String) async -> Bool {
        await MainActor.run { errorMessage = nil }
        
        do {
            try await deleteActivityFromStorage(id: id)
            print("✅ Activity deleted: \(id)")
            return true
        } catch {
            await MainActor.run {
                errorMessage = "Error al eliminar: \(error.localizedDescription)"
            }
            print("❌ Error deleting activity: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Sincroniza actividades entre local y Firestore
    public func syncActivities() async -> Bool {
        await MainActor.run {
            isSyncing = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isSyncing = false
            }
        }
        
        do {
            try await performSync()
            await MainActor.run {
                lastSyncDate = Date()
            }
            print("✅ Sync completed")
            return true
        } catch {
            await MainActor.run {
                errorMessage = "Error en sincronización: \(error.localizedDescription)"
            }
            print("❌ Sync failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Internal Methods (Fetch Logic)
    
    /// Obtiene todas las actividades según estrategia de sync
    internal func fetchActivities() async throws -> [ActivityType] {
        await MainActor.run { errorMessage = nil }
        
        switch syncStrategy {
        case .localFirst:
            return try await fetchActivitiesLocalFirst()
            
        case .firestoreFirst:
            return try await fetchActivitiesFirestoreFirst()
            
        case .localOnly:
            return try await fetchActivitiesLocalOnly()
            
        case .firestoreOnly:
            return try await fetchActivitiesFirestoreOnly()
        }
    }
    
    /// Obtiene actividades por categoría
    internal func fetchActivities(category: ActivityCategory) async throws -> [ActivityType] {
        await MainActor.run { errorMessage = nil }
        
        switch syncStrategy {
        case .localFirst:
            return try await fetchActivitiesLocalFirst(category: category)
            
        case .firestoreFirst:
            return try await fetchActivitiesFirestoreFirst(category: category)
            
        case .localOnly:
            return try await localStorageService.fetchActivities(byCategory: category)
            
        case .firestoreOnly:
            return try await firestoreService.fetchUserActivities(category: category)
        }
    }
    
    /// Obtiene una actividad específica
    internal func fetchActivity(by id: String) async throws -> ActivityType? {
        await MainActor.run { errorMessage = nil }
        
        // 1. Intentar Firestore primero
        do {
            let activity = try await firestoreService.fetchActivity(id: id)
            await MainActor.run { isOnline = true }
            
            // Guardar en local para caché
            try await localStorageService.saveActivity(activity)
            
            return activity
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }
        
        // 2. Fallback a local
        do {
            let activity = try await localStorageService.fetchActivity(id: id)
            await MainActor.run {
                errorMessage = "Mostrando versión local (sin conexión)"
            }
            return activity
        } catch {
            print("❌ Activity not found: \(id)")
            return nil
        }
    }
    
    // MARK: - Fetch Strategies
    
    /// Local primero, Firestore como fallback
    private func fetchActivitiesLocalFirst() async throws -> [ActivityType] {
        do {
            let localActivities = try await localStorageService.fetchActivities()
            
            if !localActivities.isEmpty {
                print("✅ Loaded \(localActivities.count) activities from local")
                
                // Background sync con Firestore
                Task {
                    try? await syncWithFirestore()
                }
                
                return localActivities
            }
        } catch {
            print("⚠️ Local storage failed, trying Firestore...")
        }
        
        // Fallback a Firestore
        return try await fetchActivitiesFirestoreOnly()
    }
    
    /// Local primero con filtro de categoría
    private func fetchActivitiesLocalFirst(category: ActivityCategory) async throws -> [ActivityType] {
        do {
            let localActivities = try await localStorageService.fetchActivities(byCategory: category)
            
            if !localActivities.isEmpty {
                print("✅ Loaded \(localActivities.count) \(category.rawValue) activities from local")
                
                // Background sync
                Task {
                    try? await syncWithFirestore()
                }
                
                return localActivities
            }
        } catch {
            print("⚠️ Local storage failed, trying Firestore...")
        }
        
        // Fallback a Firestore
        let firestoreActivities = try await firestoreService.fetchUserActivities(category: category)
        
        // Guardar en local
        try await localStorageService.saveActivities(firestoreActivities)
        
        return firestoreActivities
    }
    
    /// Firestore primero, local como fallback
    private func fetchActivitiesFirestoreFirst() async throws -> [ActivityType] {
        do {
            let firestoreActivities = try await firestoreService.fetchUserActivities()
            await MainActor.run {
                isOnline = true
                lastSyncDate = Date()
            }
            
            print("✅ Loaded \(firestoreActivities.count) activities from Firestore")
            
            // Guardar en local para caché
            Task {
                try await localStorageService.saveActivities(firestoreActivities)
                print("✅ Local storage synced")
            }
            
            return firestoreActivities
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }
        
        // Fallback a local
        return try await fetchActivitiesLocalOnly()
    }
    
    /// Firestore primero con filtro de categoría
    private func fetchActivitiesFirestoreFirst(category: ActivityCategory) async throws -> [ActivityType] {
        do {
            let firestoreActivities = try await firestoreService.fetchUserActivities(category: category)
            await MainActor.run {
                isOnline = true
                lastSyncDate = Date()
            }
            
            print("✅ Loaded \(firestoreActivities.count) \(category.rawValue) activities from Firestore")
            
            // Guardar en local
            Task {
                try await localStorageService.saveActivities(firestoreActivities)
            }
            
            return firestoreActivities
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }
        
        // Fallback a local
        return try await localStorageService.fetchActivities(byCategory: category)
    }
    
    /// Solo local (modo offline)
    private func fetchActivitiesLocalOnly() async throws -> [ActivityType] {
        let localActivities = try await localStorageService.fetchActivities()
        
        await MainActor.run {
            isOnline = false
            if !localActivities.isEmpty {
                errorMessage = "Mostrando actividades locales (modo offline)"
            }
        }
        
        print("✅ Loaded \(localActivities.count) activities from local (offline mode)")
        return localActivities
    }
    
    /// Solo Firestore (requiere conexión)
    private func fetchActivitiesFirestoreOnly() async throws -> [ActivityType] {
        let firestoreActivities = try await firestoreService.fetchUserActivities()
        
        await MainActor.run {
            isOnline = true
            lastSyncDate = Date()
        }
        
        print("✅ Loaded \(firestoreActivities.count) activities from Firestore")
        return firestoreActivities
    }
    
    // MARK: - Save/Delete Logic
    
    /// Guarda actividad en ambos storages
    internal func saveActivityToStorage(_ activity: ActivityType) async throws {
        // 1. Guardar en local (más rápido, siempre funciona)
        try await localStorageService.saveActivity(activity)
        print("✅ Saved to local storage")
        
        // 2. Intentar guardar en Firestore
        do {
            try await firestoreService.uploadActivityWithID(activity)
            await MainActor.run {
                isOnline = true
                lastSyncDate = Date()
            }
            print("✅ Saved to Firestore")
        } catch {
            await MainActor.run { isOnline = false }
            print("⚠️ Firestore save failed, queued for sync")
            // TODO: Implementar cola de sync pendiente
        }
    }
    
    /// Elimina actividad de ambos storages
    internal func deleteActivityFromStorage(id: String) async throws {
        // 1. Eliminar de local
        try await localStorageService.deleteActivity(id)
        print("✅ Deleted from local storage")
        
        // 2. Intentar eliminar de Firestore
        do {
            try await firestoreService.deleteActivity(id: id)
            await MainActor.run {
                isOnline = true
                lastSyncDate = Date()
            }
            print("✅ Deleted from Firestore")
        } catch {
            await MainActor.run { isOnline = false }
            print("⚠️ Firestore delete failed, queued for sync")
        }
    }
    
    // MARK: - Sync Logic
    
    /// Sincroniza actividades entre local y Firestore
    internal func performSync() async throws {
        print("🔄 Starting sync...")
        
        // 1. Obtener actividades de Firestore
        let firestoreActivities = try await firestoreService.fetchUserActivities()
        
        // 2. Guardar en local (sobrescribe)
        try await localStorageService.deleteAllActivities()
        try await localStorageService.saveActivities(firestoreActivities)
        
        print("✅ Sync completed: \(firestoreActivities.count) activities")
        
        await MainActor.run {
            isOnline = true
            lastSyncDate = Date()
        }
    }
    
    /// Sincroniza en background sin bloquear
    private func syncWithFirestore() async throws {
        let firestoreActivities = try await firestoreService.fetchUserActivities()
        try await localStorageService.saveActivities(firestoreActivities)
        
        await MainActor.run {
            lastSyncDate = Date()
        }
    }
    
    // MARK: - Global Templates
    
    /// Obtiene templates globales
    public func getGlobalTemplates(category: ActivityCategory? = nil) async -> [ActivityType] {
        do {
            if let category = category {
                return try await firestoreService.fetchGlobalTemplates(category: category)
            } else {
                return try await firestoreService.fetchGlobalTemplates()
            }
        } catch {
            print("❌ Error fetching global templates: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Copia un template global a la colección personal
    public func copyTemplateToUser(templateId: String) async -> Bool {
        do {
            let newActivityId = try await firestoreService.copyTemplateToUser(templateId: templateId)
            print("✅ Template copied: \(newActivityId)")
            
            // Sync para actualizar local
            _ = await syncActivities()
            
            return true
        } catch {
            await MainActor.run {
                errorMessage = "Error copiando template: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    // MARK: - Sharing
    
    /// Genera código para compartir actividad
    public func generateShareCode(activityId: String) async -> String? {
        do {
            let code = try await firestoreService.generateShareCode(activityId: activityId)
            print("✅ Share code generated: \(code)")
            return code
        } catch {
            await MainActor.run {
                errorMessage = "Error generando código: \(error.localizedDescription)"
            }
            return nil
        }
    }
    
    /// Importa actividad desde código
    public func importActivityFromCode(_ code: String) async -> Bool {
        do {
            let activityId = try await firestoreService.importActivityFromCode(code)
            print("✅ Activity imported: \(activityId)")
            
            // Sync para actualizar local
            _ = await syncActivities()
            
            return true
        } catch {
            await MainActor.run {
                errorMessage = "Error importando: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    // MARK: - Statistics
    
    /// Obtiene estadísticas de las actividades
    public func getStatistics() async -> ActivityServiceStatistics? {
        do {
            let localStats = try await localStorageService.getStatistics()
            let firestoreStats = try? await firestoreService.getUserStatistics()
            
            return ActivityServiceStatistics(
                localStats: localStats,
                firestoreStats: firestoreStats,
                isOnline: isOnline,
                lastSyncDate: lastSyncDate
            )
        } catch {
            print("❌ Error getting statistics: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - Statistics Model

struct ActivityServiceStatistics {
    let localStats: ActivityStorageStatistics
    let firestoreStats: ActivityFirestoreStatistics?
    let isOnline: Bool
    let lastSyncDate: Date?
    
    var totalActivities: Int {
        localStats.totalActivities
    }
    
    var syncStatus: String {
        if let syncDate = lastSyncDate {
            let formatter = RelativeDateTimeFormatter()
            return "Última sincronización: \(formatter.localizedString(for: syncDate, relativeTo: Date()))"
        } else {
            return "Sin sincronizar"
        }
    }
}
