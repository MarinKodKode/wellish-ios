//
//  PlanRepositoryProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation

public protocol PlanServiceProtocol {
    
    func savePlanLocally(_ plan : Plan) async -> Bool
    
    func savePlanRemote(_ plan : Plan) async -> Bool
    
    func fetchPlans() async throws -> [Plan]
    
    func fetchPlan(by id : String) async throws -> Plan?
    
}
