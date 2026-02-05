//
//  PlanService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation
import FirebaseFirestore

final class PlanFirebaseService {
    
    private let db = Firestore.firestore()
    private let plansCollection = "plans"
    
    @MainActor
    func uploadPlan(_ plan : Plan) async throws -> String {
        let docRef = try db.collection(plansCollection).addDocument(from : plan)
        return docRef.documentID
    }
    
    @MainActor
    func uploadPlanWithID(_ plan : Plan) async throws {
        try db.collection(plansCollection)
            .document(plan.id)
            .setData(from : plan)
    }
    
    @MainActor
    func fetchPlans() async throws -> [Plan] {
        let snapshot = try await db.collection(plansCollection).getDocuments()
        let plans = snapshot.documents.compactMap { doc -> Plan? in
            try? doc.data(as : Plan.self)
        }
        return plans
    }
    
    @MainActor
    func fetchPlans(for userId: String) async throws -> [Plan] {
        let snapshot = try await db.collection(plansCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        let plans = snapshot.documents.compactMap { doc -> Plan? in
            try? doc.data(as: Plan.self)
        }
        return plans
    }
    
    @MainActor
    func fetchPlan(with id : String) async throws -> Plan {
        let document = try await db.collection(plansCollection)
            .document(id)
            .getDocument()
        
        guard document.exists else {
            throw NSError (
                domain : "",
                code : 404,
                userInfo : [NSLocalizedDescriptionKey : "Plan not found"]
            )
        }
        
        let plan = try document.data(as : Plan.self)
        return plan
    }
    
    //MARK: - Update plans async/await methods
    
    @MainActor
    func updatePlan(_ plan : Plan) async throws {
        var updatePlan = plan
        updatePlan.updatedAt = Date()
        
        try db.collection(plansCollection)
            .document(plan.id)
            .setData(from : updatePlan, merge : true)
    }
    
    //MARK: - Delete plan async await methods
    func deletePlan(id : String) async throws {
        try await db.collection(plansCollection)
            .document(id)
            .delete()
    }
    
    
    //MARK: - Querys
    @MainActor
    func fetchPlans(byCategory category : String) async throws -> [Plan] {
        let snapshot = try await db.collection(plansCollection)
            .whereField("category", isEqualTo: category)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> Plan? in
            try? doc.data(as : Plan.self)
        }
    }
    
    
}
