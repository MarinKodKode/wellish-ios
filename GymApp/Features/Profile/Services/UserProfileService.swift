//
//  UserProfileService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    private let collection = "users"
    
    private init() {}
    
    // MARK: - Fetching
    
    func fetchCurrentUser() async -> UserProfile? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let docRef = db.collection(collection).document(uid)
        do {
            let snapshot = try await docRef.getDocument()
            guard let profile = try? snapshot.data(as: UserProfile.self) else {
                return nil
            }
            return profile
        }catch{
            return nil
        }
    }
    
    // MARK: - Creation (Sign Up)
    
    /// Creates the initial database document for a new user
    func createInitialProfile(user: User, username: String) async throws {
        let uid = user.uid
        
        let newProfile = UserProfile(
            username: username,
            email: user.email ?? "",
            bio: nil,
            photoURL: nil,
            createdDate: Date(),
            lastActiveDate: Date(),
            fcmTokens: [],
            isPremium: false,
            onboardingCompleted: false,
            version: "1.0",
            physicalProfile: PhysicalProfile(gender: .preferNotToSay, birthDate: nil, height: 170, currentWeight: 70, bodyFatPercentage: nil),
            preferences: UserPreferences(unitSystem: .metric, workoutReminderTime: nil, allowNotifications: false, restTimerDuration: 60),
            goals: FitnessGoal(primaryGoal: .keepFit, targetWeight: nil, weeklyWorkoutDays: 3, experienceLevel: .beginner),
            stats: UserStats(routinesCompleted: 0, workoutsCompleted: 0, currentStreak: 0, highestStreak: 0, totalLiftedWeight: 0, totalWorkoutMinutes: 0)
        )
        
        try db.collection(collection).document(uid).setData(from: newProfile)
    }
    
    func updateProfileData(_ data: [String: Any]) async {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        do {
            try await db.collection(collection).document(uid).updateData(data)
        }catch{
            return
        }
        
    }
    
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let name = user.displayName ?? "Name not available"
        let email = user.email ?? "Not available email"
        let urlPhoto = user.photoURL
        
        if let url = urlPhoto {
            print("Profile picture - \(url)")
        }
        
    }
}
