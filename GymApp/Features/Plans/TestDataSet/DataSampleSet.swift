//
//  DataSample.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/10/25.
//

import Foundation

public let gymActivity = Exercise(
    name: "Push Day",
    category: "Gym",
    equipment: "Barra",
    muscles: ["Pecho", "Tríceps"]
)

public let runActivity = Exercise(
    name: "Correr 5K",
    category: "Cardio",
    muscles: ["Piernas"]
)

public let sampleExerciseLibrary : [Exercise] = [
    Exercise(
        name: "Bench Press",
        category: "Chest",
        equipment: "Barbell",
        muscles: ["Chest", "Triceps"]
    ),
    Exercise(
        name: "Squat",
        category: "Legs",
        equipment: "Barbell",
        muscles: ["Quadriceps", "Glutes"]
    ),
    Exercise(
        name: "Deadlift",
        category: "Back",
        equipment: "Barbell",
        muscles: ["Back", "Hamstrings"]
    ),
    Exercise(
        name: "Overhead Press",
        category: "Shoulders",
        equipment: "Barbell",
        muscles: ["Deltoids"]
    ),
    Exercise(
        name: "Pull-ups",
        category: "Back",
        equipment: "Bodyweight",
        muscles: ["Lats", "Biceps"]
    ),
    Exercise(
        name: "Lunges",
        category: "Legs",
        equipment: "Dumbbell",
        muscles: ["Quadriceps", "Glutes", "Hamstrings"]
    )
]
