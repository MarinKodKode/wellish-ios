//
//  PlanService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation

final class PlanService : PlanServiceProtocol {
    
    public var errorMessage : String?
    
    public var lastSyncDate : Date?
    
    private let firestoreService = PlanFirebaseService()
    
    private let localStorageService = PlanLocalStorageService()
    
    
    //MARK: - Public interface methods
    
    public func getPlans() async -> [Plan] {
        do {
            let plans = try await self.fetchPlans()
            return plans
        }catch {
            return []
        }
    }
    
    public func getPlan(by id : String) async -> Plan? {
        do {
            let plan = try await fetchPlan(by: id)
            return plan
        } catch {
            return nil
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
        
        let remoteSuccess = await updatePlanRemote(updatedPlan)
        
        let localSuccess = await updatePlanLocally(updatedPlan)
        
        return remoteSuccess || localSuccess
    }
    
    //MARK: - Private methods
    
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
                    errorMessage = "Showing local plans."
                }
                return localPlans
            } catch {
                errorMessage = "Could nos load plans \(error.localizedDescription)"
                return []
            }
        }
    }
    
    internal func fetchPlan(by id: String) async throws -> Plan? {
        errorMessage = nil
        do {
            let loadedPlan = try await firestoreService.fetchPlan(with: id)
            try await localStorageService.savePlan(loadedPlan)
            return loadedPlan
        } catch {
            print("Error fetching from Firebase : \(error)")
        }
        
        do {
            let loadedPlan = try await localStorageService.fetchPlan(id: id)
            return loadedPlan
        } catch {
            return nil
        }
    }
    
    internal func savePlanInLocalStorage(_ plan: Plan) async -> Bool {
        do {
            try await localStorageService.savePlan(plan)
            return true
        }catch {
            //Send analitycs event
            print("Could not save plans in localStorage")
            return false
        }
    }
    
    internal func savePlanInFirebaseStorage(_ plan : Plan) async -> Bool {
        do {
            _ = try await firestoreService.uploadPlanWithID(plan)
            return true
        }catch {
            print("Could not send plan to remote server")
            //Send analytics event
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
