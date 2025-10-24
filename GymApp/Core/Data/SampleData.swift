//
//  SampleData.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI
import Foundation

//MARK: - ONBOARDINGVIEW

let slides : [OnboardingSlide] = [
    OnboardingSlide(
        title: "No Excuses",
        subtitle: "Just Do The Workout",
        quote: "Fitness is not about being better than someone else. It's about being better than you used to be.",
        imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    ),
    OnboardingSlide(
        title: "Push Your Limits",
        subtitle: "Transform Your Body",
        quote: "The only bad workout is the one that didn't happen.",
        imageURL: "https://images.unsplash.com/photo-1549476464-37392f717541?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    ),
    OnboardingSlide(
        title: "Start Today",
        subtitle: "Build Your Future",
        quote: "Your body can do it. It's time to convince your mind.",
        imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    )
]


// MARK: - MAIN HOME VIEW ROUTINES

let bodyParts = ["Full Body", "Legs", "Hands", "Upper"]

let workouts = [
    WorkoutItem(name: "Bridge", imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop", tutorials: 8, duration: 30),
    WorkoutItem(name: "Push up", imageURL: "https://images.unsplash.com/photo-1549476464-37392f717541?w=300&h=200&fit=crop", tutorials: 12, duration: 60),
    WorkoutItem(name: "Hip Thrust", imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300&h=200&fit=crop", tutorials: 10, duration: 45)
]


// MARK: - SAMPLE DATA FOR Exercises

let benchPress = Exercise(
    name: "Bench Press",
    category: "Chest",
    equipment: "Barbell",
    muscles: ["Pectorals", "Triceps", "Anterior Deltoids"],
    thumbnailURL: URL(string: "https://example.com/bench-press.jpg")
)

let squat = Exercise(
    name: "Barbell Back Squat",
    category: "Legs",
    equipment: "Barbell",
    muscles: ["Quadriceps", "Glutes", "Hamstrings"],
    thumbnailURL: URL(string: "https://example.com/squat.jpg")
)

let deadlift = Exercise(
    name: "Deadlift",
    category: "Back",
    equipment: "Barbell",
    muscles: ["Erector Spinae", "Glutes", "Hamstrings", "Trapezius"],
    thumbnailURL: URL(string: "https://example.com/deadlift.jpg")
)

let overheadPress = Exercise(
    name: "Overhead Press",
    category: "Shoulders",
    equipment: "Barbell",
    muscles: ["Deltoids", "Triceps", "Trapezius"],
    thumbnailURL: URL(string: "https://example.com/overhead-press.jpg")
)

let pullUp = Exercise(
    name: "Pull-Up",
    category: "Back",
    equipment: "Pull-Up Bar",
    muscles: ["Latissimus Dorsi", "Biceps", "Rhomboids"],
    thumbnailURL: URL(string: "https://example.com/pullup.jpg")
)

let plank = Exercise(
    name: "Plank",
    category: "Core",
    equipment: "Bodyweight",
    muscles: ["Rectus Abdominis", "Transverse Abdominis"],
    thumbnailURL: URL(string: "https://example.com/plank.jpg")
)

// MARK: - Sample Routines

let routines: [GymActivity] = [
        // 💪 Full Body Strength
    GymActivity(
            name: "Full Body Strength",
            description: "A balanced full-body routine for strength and hypertrophy.",
            
            sets: [
                RoutineSet(
                    exercise: benchPress,
                    series: [
                        Serie(repetitions: 10, idealWeightKg: 60, restSeconds: 90),
                        Serie(repetitions: 10, idealWeightKg: 60, restSeconds: 90),
                        Serie(repetitions: 8, idealWeightKg: 70, restSeconds: 120)
                    ],
                    restBetweenSeriesSeconds: 90,
                    intensityTechnique: .none
                ),
                RoutineSet(
                    exercise: squat,
                    series: [
                        Serie(repetitions: 10, idealWeightKg: 80, restSeconds: 90),
                        Serie(repetitions: 10, idealWeightKg: 80, restSeconds: 90),
                        Serie(repetitions: 8, idealWeightKg: 90, restSeconds: 120)
                    ],
                    restBetweenSeriesSeconds: 90
                ),
                RoutineSet(
                    exercise: deadlift,
                    series: [
                        Serie(repetitions: 5, idealWeightKg: 120, restSeconds: 120),
                        Serie(repetitions: 5, idealWeightKg: 120, restSeconds: 120)
                    ],
                    restBetweenSeriesSeconds: 120
                )
            ],
            tags: ["Beginner", "Full Body", "Barbell"],
            category: "Strength",
            estimatedDurationMinutes: 60
        ),

        // 🏃‍♂️ Beginner Running Plan
    GymActivity(
            name: "Beginner 5K Plan",
            description: "Couch to 5K in 8 weeks. Walk-run intervals.",
            sets: [
                RoutineSet(
                    exercise: Exercise(
                        name: "Run/Walk Intervals",
                        category: "Cardio",
                        equipment: "Running Shoes",
                        muscles: ["Quadriceps", "Calves", "Heart"]
                    ),
                    series: [
                        Serie(repetitions: 1, tempo: "Run 1 min, Walk 2 min", restSeconds: 60),
                        Serie(repetitions: 1, tempo: "Run 1 min, Walk 2 min", restSeconds: 60),
                        Serie(repetitions: 1, tempo: "Run 1 min, Walk 2 min", restSeconds: 60),
                        Serie(repetitions: 1, tempo: "Run 1 min, Walk 2 min", restSeconds: 60),
                        Serie(repetitions: 1, tempo: "Run 1 min, Walk 2 min", restSeconds: 60)
                    ],
                    notes: "Keep pace comfortable. Focus on consistency."
                )
            ],
            tags: ["Running", "Beginner", "Cardio"],
            category: "Cardio",
            estimatedDurationMinutes: 30
        ),

    GymActivity(
            name: "Isometric Core Flow",
            description: "Hold-based core routine for stability and endurance.",
            sets: [
                RoutineSet(
                    exercise: plank,
                    series: [
                        Serie(repetitions: 1, idealWeightKg: nil, tempo: "Hold 45s", restSeconds: 30),
                        Serie(repetitions: 1, idealWeightKg: nil, tempo: "Hold 45s", restSeconds: 30),
                        Serie(repetitions: 1, idealWeightKg: nil, tempo: "Hold 60s", restSeconds: 60)
                    ],
                    notes: "Keep back flat. Breathe steadily."
                ),
                RoutineSet(
                    exercise: Exercise(
                        name: "Wall Sit",
                        category: "Legs",
                        equipment: "Wall",
                        muscles: ["Quadriceps"]
                    ),
                    series: [
                        Serie(repetitions: 1, tempo: "Hold 30s", restSeconds: 30),
                        Serie(repetitions: 1, tempo: "Hold 30s", restSeconds: 30),
                        Serie(repetitions: 1, tempo: "Hold 45s", restSeconds: 60)
                    ]
                )
            ],
            
            tags: ["Core", "Isometric", "Bodyweight"],
            category: "Mobility",
            estimatedDurationMinutes: 20
        ),

    GymActivity(
            name: "Cycling HIIT",
            description: "High-Intensity Interval Training on the bike.",
            sets: [
                RoutineSet(
                    exercise: Exercise(
                        name: "Indoor Cycling",
                        category: "Cardio",
                        equipment: "Stationary Bike",
                        muscles: ["Quadriceps", "Glutes", "Cardiovascular"]
                    ),
                    series: [
                        Serie(repetitions: 1, tempo: "Warm-up: 5min easy", restSeconds: 0),
                        Serie(repetitions: 1, tempo: "Sprint: 30s max effort", restSeconds: 90),
                        Serie(repetitions: 1, tempo: "Recovery: 2min", restSeconds: 0),
                        Serie(repetitions: 1, tempo: "Sprint: 30s max effort", restSeconds: 90),
                        Serie(repetitions: 1, tempo: "Recovery: 2min", restSeconds: 0),
                        Serie(repetitions: 1, tempo: "Sprint: 30s max effort", restSeconds: 90),
                        Serie(repetitions: 1, tempo: "Cool-down: 5min", restSeconds: 0)
                    ],
                    notes: "Adjust resistance to simulate hill sprints."
                )
            ],
            tags: ["Cycling", "HIIT", "Cardio"],
            category: "Cardio",
            estimatedDurationMinutes: 45
        ),

        // 🔥 Upper Body Blast
    GymActivity(
            name: "Upper Body Blast",
            description: "Push-pull upper body workout with supersets.",
            sets: [
                RoutineSet(
                    exercise: overheadPress,
                    series: [
                        Serie(
                            repetitions: 10,
                            idealWeightKg: 40,
                            restSeconds: 60
                        ),
                        Serie(
                            repetitions: 10,
                            idealWeightKg: 40,
                            restSeconds: 60
                        ),
                        Serie(
                            repetitions: 8,
                            idealWeightKg: 45,
                            restSeconds: 90
                        )
                    ],
                    notes: "Superset with Pull-Ups",
                    intensityTechnique: .superset
                ),
                RoutineSet(
                    exercise: pullUp,
                    series: [
                        Serie(
                            repetitions: 8,
                            idealWeightKg: nil,
                            restSeconds: 60
                        ),
                        Serie(
                            repetitions: 8,
                            idealWeightKg: nil,
                            restSeconds: 60
                        ),
                        Serie(
                            repetitions: 6,
                            idealWeightKg: nil,
                            restSeconds: 90
                        )
                    ],
                    notes: "Use band if needed",
                    intensityTechnique: .superset
                )
            ],
            tags: ["Upper Body", "Superset", "Intermediate"],
            category: "Strength",
            estimatedDurationMinutes: 50
        )
    ]


//MARK: - Workout Live Tracker Data

let workoutSession = WorkoutSession(
    name: "Dumbbell Curl",
    currentTime: 25.10,
    totalTime: 45.0,
    calories: 251,
    duration: 25,
    reps: "12 × 4 Reps"
)

let activityHistory = [
    ActivityHistoryItem(
        name: "Dumbbell Curl",
        date: "Tue, June 11",
        time: "09:50 PM",
        calories: 452,
        duration: "1 h 13 min",
        sets: 10
    ),
    ActivityHistoryItem(
        name: "Dumbbell Curl",
        date: "Mon, June 10",
        time: "07:30 PM",
        calories: 678,
        duration: "1 h 42 min",
        sets: 14
    )
]

// MARK: - Routines and plans view

// Pre-made templates
let templates: [RoutineTemplate] = [
    RoutineTemplate(
        name: "Full Body Gym",
        category: "Strength",
        description: "3-day split for full-body strength",
        imageName: "dumbbell.fill",
        estimatedDuration: 60,
        difficulty: .intermediate,
        imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Running for Beginners",
        category: "Cardio",
        description: "Couch to 5K starter plan",
        imageName: "figure.run",
        estimatedDuration: 30,
        difficulty: .beginner,
        imageURL: "https://images.unsplash.com/photo-1513593771513-7b58b6c4af38?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Isometric Flow",
        category: "Mobility",
        description: "Static holds for strength & control",
        imageName: "figure.yoga",
        estimatedDuration: 20,
        difficulty: .beginner,
        imageURL: "https://images.unsplash.com/photo-1545205597-3d9d02c29597?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Cycling HIIT",
        category: "Cardio",
        description: "High-intensity interval training",
        imageName: "bicycle",
        estimatedDuration: 45,
        difficulty: .advanced,
        imageURL: "https://plus.unsplash.com/premium_photo-1753282083852-af82471d5da7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Upper Body Blast",
        category: "Strength",
        description: "Chest, back & arms focus",
        imageName: "figure.mixed-cardio",
        estimatedDuration: 50,
        difficulty: .intermediate,
        imageURL: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    )
]


let challenges = [
    ChallengeCardModel(
        title: "Step Into Fitness!",
        subtitle: "Daily Steps Challenge",
        mainNumber: "10,000",
        unit: "Steps",
        progress: 0.65,
        progressText: "6,500 / 10,000",
        buttonText: "Continue Walking",
        colors: [Color(red: 0.1, green: 0.2, blue: 0.4), Color(red: 0.2, green: 0.3, blue: 0.6)], // Navy blue gradient
        imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop&crop=faces",
        icon: "figure.walk"
    ),
    ChallengeCardModel(
        title: "Hydration Hero",
        subtitle: "Daily Water Challenge",
        mainNumber: "8",
        unit: "Glasses",
        progress: 0.375,
        progressText: "3 / 8 glasses",
        buttonText: "Log Water",
        colors: [Color(red: 0.1, green: 0.3, blue: 0.4), Color(red: 0.2, green: 0.4, blue: 0.5)], // Deep teal gradient
        imageUrl: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=200&h=200&fit=crop",
        icon: "drop.fill"
    ),
    ChallengeCardModel(
        title: "Streak Master",
        subtitle: "7-Day Workout Streak",
        mainNumber: "5",
        unit: "Days",
        progress: 0.714,
        progressText: "5 / 7 days",
        buttonText: "Keep Going",
        colors: [Color(red: 0.3, green: 0.1, blue: 0.4), Color(red: 0.5, green: 0.2, blue: 0.6)], // Deep purple gradient
        imageUrl: "https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=200&h=200&fit=crop",
        icon: "flame.fill"
    ),
    ChallengeCardModel(
        title: "Sleep Champion",
        subtitle: "Quality Sleep Challenge",
        mainNumber: "7.5",
        unit: "Hours",
        progress: 0.85,
        progressText: "7.5 / 8 hours",
        buttonText: "View Sleep",
        colors: [Color(red: 0.2, green: 0.1, blue: 0.3), Color(red: 0.3, green: 0.2, blue: 0.5)], // Dark indigo gradient
        imageUrl: "https://images.unsplash.com/photo-1520206183501-b80df61043c2?w=200&h=200&fit=crop",
        icon: "moon.fill"
    ),
    ChallengeCardModel(
        title: "Mindful Moments",
        subtitle: "Daily Meditation Challenge",
        mainNumber: "15",
        unit: "Minutes",
        progress: 0.5,
        progressText: "15 / 30 minutes",
        buttonText: "Start Session",
        colors: [Color(red: 0.1, green: 0.3, blue: 0.2), Color(red: 0.2, green: 0.4, blue: 0.3)], // Dark forest green gradient
        imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop",
        icon: "leaf.fill"
    )
]
