//
//  PlanService.swift
//  Wellish
//

import Foundation



// MARK: - PlanService

final class PlanService: PlanServiceProtocol, ObservableObject {

    // MARK: - Properties

    public var errorMessage: String?
    public var lastSyncDate: Date?

     let firestoreService = PlanFirebaseService()
    private let localStorageService = PlanLocalStorageService()

    // MARK: - Public Interface (Existente — sin cambios)

    public func getPlans() async -> [Plan] {
        do {
            return try await fetchPlans()
        } catch {
            return []
        }
    }

    public func getPlan(by id: String) async -> Plan? {
        do {
            return try await fetchPlan(by: id)
        } catch {
            return nil
        }
    }

    public func getPlans(for userId: String) async -> [Plan] {
        do {
            return try await fetchPlans(for: userId)
        } catch {
            return []
        }
    }

    public func savePlanLocally(_ plan: Plan) async -> Bool {
        return await savePlanInLocalStorage(plan)
    }

    public func savePlanRemote(_ plan: Plan) async -> Bool {
        return await savePlanInFirebaseStorage(plan)
    }

    public func updatePlan(_ plan: Plan) async -> Bool {
        var updatedPlan = plan
        updatedPlan.updatedAt = Date()
        let remote = await updatePlanRemote(updatedPlan)
        let local = await updatePlanLocally(updatedPlan)
        return remote || local
    }

    // MARK: - Global Plans (Plantillas de Wellish)

    /// Obtiene todos los planes plantilla globales
    public func getGlobalPlans() async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans()
        } catch {
            print("❌ Error fetching global plans: \(error.localizedDescription)")
            return []
        }
    }

    /// Obtiene planes plantilla filtrados por goal
    public func getGlobalPlans(byGoal goal: PlanGoal) async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans(byGoal: goal)
        } catch {
            print("❌ Error fetching global plans by goal: \(error.localizedDescription)")
            return []
        }
    }

    /// Obtiene planes plantilla filtrados por categoria de actividad
    public func getGlobalPlans(byCategory category: ActivityCategory) async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans(byCategory: category)
        } catch {
            print("❌ Error fetching global plans by category: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Active Plans (Planes que el usuario sigue)

    /// Obtiene los planes activos del usuario autenticado
    public func getActivePlans() async -> [Plan] {
        do {
            return try await firestoreService.fetchActivePlans()
        } catch {
            print("❌ Error fetching active plans: \(error.localizedDescription)")
            return []
        }
    }

    /// El usuario comienza a seguir un plan plantilla global
    /// Crea una copia personal con startDate = hoy
    public func followPlan(planId: String) async -> Bool {
        do {
            let newId = try await firestoreService.followGlobalPlan(planId: planId)
            print("✅ Following plan: \(newId)")
            return true
        } catch {
            errorMessage = "Error al seguir el plan: \(error.localizedDescription)"
            print("❌ Error following plan: \(error.localizedDescription)")
            return false
        }
    }

    /// El usuario deja de seguir un plan activo
    public func unfollowPlan(id: String) async -> Bool {
        do {
            try await firestoreService.unfollowActivePlan(id: id)
            print("✅ Unfollowed plan: \(id)")
            return true
        } catch {
            errorMessage = "Error al dejar el plan: \(error.localizedDescription)"
            return false
        }
    }

    /// Actualiza el progreso de un plan activo
    public func updateActivePlan(_ plan: Plan) async -> Bool {
        do {
            try await firestoreService.updateActivePlan(plan)
            _ = await updatePlanLocally(plan)
            return true
        } catch {
            errorMessage = "Error actualizando plan activo: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: - Internal Fetch (Existente — sin cambios)

    internal func fetchPlans() async throws -> [Plan] {
        errorMessage = nil
        do {
            let firebasePlans = try await firestoreService.fetchPlans()
            lastSyncDate = Date()
            Task {
                do {
                    try await localStorageService.savePlans(firebasePlans)
                } catch {
                    print("Error syncing in local storage \(error)")
                }
            }
            return firebasePlans
        } catch {
            do {
                let localPlans = try await localStorageService.fetchPlans()
                if !localPlans.isEmpty {
                    errorMessage = "Mostrando planes locales."
                }
                return localPlans
            } catch {
                errorMessage = "No se pudieron cargar los planes: \(error.localizedDescription)"
                return []
            }
        }
    }

    internal func fetchPlan(by id: String) async throws -> Plan? {
        errorMessage = nil
        do {
            let plan = try await firestoreService.fetchPlan(with: id)
            try await localStorageService.savePlan(plan)
            return plan
        } catch {
            print("Error fetching from Firebase: \(error)")
        }
        do {
            return try await localStorageService.fetchPlan(id: id)
        } catch {
            return nil
        }
    }

    internal func fetchPlans(for userId: String) async throws -> [Plan] {
        errorMessage = nil
        do {
            let firebasePlans = try await firestoreService.fetchPlans(for: userId)
            lastSyncDate = Date()
            Task {
                do {
                    try await localStorageService.savePlans(firebasePlans)
                } catch {
                    print("Error syncing in local storage \(error)")
                }
            }
            return firebasePlans
        } catch {
            do {
                let localPlans = try await localStorageService.fetchPlans()
                if !localPlans.isEmpty {
                    errorMessage = "Mostrando planes locales."
                }
                return localPlans
            } catch {
                errorMessage = "No se pudieron cargar los planes: \(error.localizedDescription)"
                return []
            }
        }
    }

    internal func savePlanInLocalStorage(_ plan: Plan) async -> Bool {
        do {
            try await localStorageService.savePlan(plan)
            return true
        } catch {
            print("Could not save plan in localStorage")
            return false
        }
    }

    internal func savePlanInFirebaseStorage(_ plan: Plan) async -> Bool {
        do {
            try await firestoreService.uploadPlanWithID(plan)
            return true
        } catch {
            print("Could not send plan to remote server")
            return false
        }
    }

    internal func updatePlanRemote(_ plan: Plan) async -> Bool {
        return await savePlanInFirebaseStorage(plan)
    }

    internal func updatePlanLocally(_ plan: Plan) async -> Bool {
        do {
            try await localStorageService.updatePlan(plan)
            return true
        } catch {
            return false
        }
    }
}
