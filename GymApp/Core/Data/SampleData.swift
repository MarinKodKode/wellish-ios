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

let routines: [Routine] = [
        // 💪 Full Body Strength
        Routine(
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
        Routine(
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

        Routine(
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

        Routine(
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
        Routine(
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
