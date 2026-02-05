//
//  ExerciseFirebaseService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation
import FirebaseFirestore

final class ExerciseFirebaseService {
    
    private let db = Firestore.firestore()
    private let exercisesCollection = "exercises"
    
    @MainActor
    func uploadExercise(_ exercise : Exercise) async throws -> String {
        let docRef = try db.collection(exercisesCollection).addDocument(from : exercise)
        return docRef.documentID
    }
    
    @MainActor
    func uploadPlanWithID(_ exercise : Exercise) async throws {
        try db.collection(exercisesCollection)
            .document(exercise.id)
            .setData(from : exercise)
    }
    
    @MainActor
    func fetchExercisex() async throws -> [Exercise] {
        let snapshot = try await db.collection(exercisesCollection).getDocuments()
        let exercises = snapshot.documents.compactMap { doc -> Exercise? in
            try? doc.data(as : Exercise.self)
        }
        return exercises
    }
    
    @MainActor
    func fetchPlan(with id : String) async throws -> Exercise {
        let document = try await db.collection(exercisesCollection)
            .document(id)
            .getDocument()
        
        guard document.exists else {
            throw NSError (
                domain : "",
                code : 404,
                userInfo : [NSLocalizedDescriptionKey : "Plan not found"]
            )
        }
        
        let exercise = try document.data(as : Exercise.self)
        return exercise
    }
    
    //MARK: - Update Exercise async/await methods
    
    @MainActor
    func updateExercise(_ exercise : Exercise) async throws {
        let updateExercise = exercise
//        updateExercise.updatedAt = Date()
        
        try db.collection(exercisesCollection)
            .document(exercise.id)
            .setData(from : updateExercise, merge : true)
    }
    
    //MARK: - Delete plan async await methods
    func deleteExercise(id : String) async throws {
        try await db.collection(exercisesCollection)
            .document(id)
            .delete()
    }
    
    
    //MARK: - Querys
    @MainActor
    func fetchExercises(byCategory category : ExerciseCategory) async throws -> [Exercise] {
        let snapshot = try await db.collection(exercisesCollection)
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> Exercise? in
            try? doc.data(as : Exercise.self)
        }
    }
    
    
}
