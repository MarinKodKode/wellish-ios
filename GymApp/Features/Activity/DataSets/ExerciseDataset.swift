//
//  ExerciseDatset.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation

public struct ExerciseDataset {
    
    public static let gymExercises: [Exercise] = [
        // MARK: - Pecho
        Exercise(
            name: "Press de banca con barra",
            category: .chest, // Usando .chest
            equipment: "Barra y banco",
            muscles: ["Pectorales", "Tríceps", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Bench_Press_on_Decline_Bench_at_the_Gym.jpg") // URL real
        ),
        Exercise(
            name: "Press de banca inclinado con mancuernas",
            category: .chest, // Usando .chest
            equipment: "Mancuernas y banco inclinado",
            muscles: ["Pectorales superiores", "Tríceps", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://i.imgur.com/G9L2rP2.jpg")
        ),
        Exercise(
            name: "Aperturas con mancuernas",
            category: .chest, // Usando .chest
            equipment: "Mancuernas y banco plano",
            muscles: ["Pectorales", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://i.imgur.com/qR8Xk6f.jpg")
        ),
        
        // MARK: - Espalda
        Exercise(
            name: "Dominadas",
            category: .back, // Usando .back
            equipment: "Barra fija",
            muscles: ["Dorsales", "Bíceps", "Trapecios"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Pullups.jpg")
        ),
        Exercise(
            name: "Remo con barra",
            category: .back, // Usando .back
            equipment: "Barra",
            muscles: ["Dorsales", "Trapecios", "Bíceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/Wb0Z8b5.jpg")
        ),
        Exercise(
            name: "Jalón al pecho en polea",
            category: .back, // Usando .back
            equipment: "Polea alta",
            muscles: ["Dorsales", "Bíceps", "Deltoides posteriores"],
            thumbnailURL: URL(string: "https://i.imgur.com/1GvK7N8.jpg")
        ),
        
        // MARK: - Piernas
        Exercise(
            name: "Sentadilla con barra",
            category: .legs, // Usando .legs
            equipment: "Barra y rack",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/60/Squat_Form.jpg")
        ),
        Exercise(
            name: "Prensa de piernas",
            category: .legs, // Usando .legs
            equipment: "Máquina de prensa",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://i.imgur.com/j8nQ5Yg.jpg")
        ),
        Exercise(
            name: "Peso muerto",
            category: .legs, // Usando .legs
            equipment: "Barra",
            muscles: ["Femorales", "Glúteos", "Espalda baja"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Deadlift.svg")
        ),
        Exercise(
            name: "Zancadas con mancuernas",
            category: .legs, // Usando .legs
            equipment: "Mancuernas",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://i.imgur.com/492r5n3.jpg")
        ),
        Exercise(
            name: "Extensiones de piernas",
            category: .legs, // Usando .legs
            equipment: "Máquina de extensiones",
            muscles: ["Cuádriceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/8Q7P1V2.jpg")
        ),
        Exercise(
            name: "Curl de piernas acostado",
            category: .legs, // Usando .legs
            equipment: "Máquina de femorales",
            muscles: ["Femorales"],
            thumbnailURL: URL(string: "https://i.imgur.com/7A6wX7h.jpg")
        ),
        Exercise(
            name: "Elevaciones de talones",
            category: .legs, // Usando .legs
            equipment: "Máquina de gemelos o barra",
            muscles: ["Gemelos"],
            thumbnailURL: URL(string: "https://i.imgur.com/P4w8Ylq.jpg")
        ),
        
        // MARK: - Hombros
        Exercise(
            name: "Press militar con barra",
            category: .shoulders, // Usando .shoulders
            equipment: "Barra",
            muscles: ["Deltoides", "Tríceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/Y4K0qT6.jpg")
        ),
        Exercise(
            name: "Elevaciones laterales",
            category: .shoulders, // Usando .shoulders
            equipment: "Mancuernas",
            muscles: ["Deltoides laterales"],
            thumbnailURL: URL(string: "https://i.imgur.com/V7w7x8z.jpg")
        ),
        Exercise(
            name: "Pájaros con mancuernas",
            category: .shoulders, // Usando .shoulders
            equipment: "Mancuernas",
            muscles: ["Deltoides posteriores", "Trapecios"],
            thumbnailURL: URL(string: "https://i.imgur.com/mU4J4lR.jpg")
        ),
        
        // MARK: - Brazos
        Exercise(
            name: "Curl de bíceps con barra",
            category: .arms, // Usando .arms
            equipment: "Barra",
            muscles: ["Bíceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/5D6x8oI.jpg")
        ),
        Exercise(
            name: "Curl de bíceps con mancuernas",
            category: .arms, // Usando .arms
            equipment: "Mancuernas",
            muscles: ["Bíceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/M6L2lRk.jpg")
        ),
        Exercise(
            name: "Extensiones de tríceps en polea",
            category: .arms, // Usando .arms
            equipment: "Polea",
            muscles: ["Tríceps"],
            thumbnailURL: URL(string: "https://i.imgur.com/3Z7wVjP.jpg")
        ),
        Exercise(
            name: "Fondos en paralelas",
            category: .arms, // Usando .arms
            equipment: "Paralelas",
            muscles: ["Tríceps", "Pectorales"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Dips.jpg")
        ),
        
        // MARK: - Core
        Exercise(
            name: "Plancha abdominal",
            category: .core, // Usando .core
            equipment: "Ninguno",
            muscles: ["Abdomen", "Espalda baja"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/18/Plank_exercise.jpg")
        ),
        Exercise(
            name: "Crunch abdominal",
            category: .core, // Usando .core
            equipment: "Ninguno",
            muscles: ["Abdomen"],
            thumbnailURL: URL(string: "https://i.imgur.com/8Q9lQ7n.jpg")
        ),
        Exercise(
            name: "Elevaciones de piernas colgado",
            category: .core, // Usando .core
            equipment: "Barra fija",
            muscles: ["Abdomen inferior", "Flexores de cadera"],
            thumbnailURL: URL(string: "https://i.imgur.com/R3Z5tF2.jpg")
        ),
        Exercise(
            name: "Russian twists",
            category: .core, // Usando .core
            equipment: "Mancuerna o balón medicinal",
            muscles: ["Oblicuos", "Abdomen"],
            thumbnailURL: URL(string: "https://i.imgur.com/V9Xg3wL.jpg")
        )
    ]
    
    
    public static let hiitExercises: [Exercise] = [
        Exercise(
            name: "Burpees",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Cuerpo completo", "Pectorales", "Piernas"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/c5/Burpee.gif")
        ),
        Exercise(
            name: "Jumping Jacks",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Hombros", "Cardio"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/87/Jumping_jack.gif")
        ),
        Exercise(
            name: "Mountain Climbers",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Abdomen", "Piernas", "Hombros"],
            thumbnailURL: URL(string: "https://i.imgur.com/W2Zt5J8.gif")
        ),
        Exercise(
            name: "High Knees",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Cardio"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/c3/High_Knees_exercise.gif")
        ),
        Exercise(
            name: "Sprints en sitio",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Cardio"],
            thumbnailURL: URL(string: "https://i.imgur.com/N5D8fW1.gif")
        ),
        Exercise(
            name: "Skater Jumps",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos", "Cardio"],
            thumbnailURL: URL(string: "https://i.imgur.com/T0bCgXl.gif")
        ),
        Exercise(
            name: "Jump Squats",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/Q9y5tC2.gif")
        ),
        Exercise(
            name: "Push-up to T Rotation",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Pectorales", "Hombros", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/1G6K9Jk.gif")
        ),
        Exercise(
            name: "Plank Jack",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Core", "Hombros", "Piernas"],
            thumbnailURL: URL(string: "https://i.imgur.com/L4ZgT2J.gif")
        ),
        Exercise(
            name: "Jump Lunges",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Cuádriceps", "Glúteos", "Cardio"],
            thumbnailURL: URL(string: "https://i.imgur.com/A6jM2tL.gif")
        ),
        Exercise(
            name: "Shadow Boxing",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Brazos", "Cardio"],
            thumbnailURL: URL(string: "https://i.imgur.com/7YhX6L4.gif")
        ),
        Exercise(
            name: "Kettlebell Swings",
            category: .hiit, // Usando .hiit
            equipment: "Kettlebell",
            muscles: ["Glúteos", "Espalda baja", "Hombros"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f6/Kettlebell_Swing.gif")
        ),
        Exercise(
            name: "Battle Ropes",
            category: .hiit, // Usando .hiit
            equipment: "Cuerdas de batalla",
            muscles: ["Brazos", "Hombros", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/8Q7P1V2.jpg")
        ),
        Exercise(
            name: "Box Jump",
            category: .hiit, // Usando .hiit
            equipment: "Caja pliométrica",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/27/Box_Jump.jpg")
        ),
        Exercise(
            name: "Plank Shoulder Taps",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Core", "Hombros"],
            thumbnailURL: URL(string: "https://i.imgur.com/K1T7lP0.gif")
        ),
        Exercise(
            name: "Jump Rope",
            category: .hiit, // Usando .hiit
            equipment: "Cuerda para saltar",
            muscles: ["Piernas", "Cardio"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8c/Jump_Rope_Exercise.gif")
        ),
        Exercise(
            name: "Side-to-Side Hops",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/T0bCgXl.gif")
        ),
        Exercise(
            name: "Squat Thrust",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Core", "Pectorales"],
            thumbnailURL: URL(string: "https://i.imgur.com/Q9y5tC2.gif")
        ),
        Exercise(
            name: "Bear Crawl",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Core", "Hombros", "Piernas"],
            thumbnailURL: URL(string: "https://i.imgur.com/V9Xg3wL.gif")
        ),
        Exercise(
            name: "Jump Tuck",
            category: .hiit, // Usando .hiit
            equipment: "Ninguno",
            muscles: ["Piernas", "Abdomen"],
            thumbnailURL: URL(string: "https://i.imgur.com/2Y5F2T8.gif")
        )
    ]
    
    
    public static let plyometricExercises: [Exercise] = [
        Exercise(
            name: "Box Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Caja pliométrica",
            muscles: ["Piernas", "Glúteos", "Core"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/27/Box_Jump.jpg")
        ),
        Exercise(
            name: "Broad Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/R8gK9Jk.gif")
        ),
        Exercise(
            name: "Depth Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Caja o plataforma",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://i.imgur.com/A6jM2tL.gif")
        ),
        Exercise(
            name: "Jump Squat",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/Q9y5tC2.gif")
        ),
        Exercise(
            name: "Lateral Bounds",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/T0bCgXl.gif")
        ),
        Exercise(
            name: "Split Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Cuádriceps", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/A6jM2tL.gif")
        ),
        Exercise(
            name: "Clapping Push-ups",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Pectorales", "Tríceps", "Hombros"],
            thumbnailURL: URL(string: "https://i.imgur.com/K1T7lP0.gif")
        ),
        Exercise(
            name: "Medicine Ball Slam",
            category: .plyometric, // Usando .plyometric
            equipment: "Balón medicinal",
            muscles: ["Hombros", "Espalda", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/V7w7x8z.jpg")
        ),
        Exercise(
            name: "Jumping Lunges",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/A6jM2tL.gif")
        ),
        Exercise(
            name: "Single-Leg Hop",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Gemelos"],
            thumbnailURL: URL(string: "https://i.imgur.com/492r5n3.jpg")
        ),
        Exercise(
            name: "Bounding",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/R8gK9Jk.gif")
        ),
        Exercise(
            name: "Lateral Hurdle Jumps",
            category: .plyometric, // Usando .plyometric
            equipment: "Vallas o conos",
            muscles: ["Piernas", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/T0bCgXl.gif")
        ),
        Exercise(
            name: "Tuck Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Piernas", "Abdomen"],
            thumbnailURL: URL(string: "https://i.imgur.com/2Y5F2T8.gif")
        ),
        Exercise(
            name: "Jump to Box Lateral Step Down",
            category: .plyometric, // Usando .plyometric
            equipment: "Caja pliométrica",
            muscles: ["Piernas", "Core"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/27/Box_Jump.jpg")
        ),
        Exercise(
            name: "Depth Drop to Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Caja o plataforma",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/A6jM2tL.gif")
        ),
        Exercise(
            name: "Burpee Jump",
            category: .plyometric, // Usando .plyometric
            equipment: "Ninguno",
            muscles: ["Cuerpo completo"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/c5/Burpee.gif")
        ),
        Exercise(
            name: "Explosive Step-Up",
            category: .plyometric, // Usando .plyometric
            equipment: "Banco o caja",
            muscles: ["Piernas", "Glúteos"],
            thumbnailURL: URL(string: "https://i.imgur.com/Q9y5tC2.gif")
        ),
        Exercise(
            name: "Medicine Ball Chest Pass",
            category: .plyometric, // Usando .plyometric
            equipment: "Balón medicinal",
            muscles: ["Pectorales", "Tríceps", "Core"],
            thumbnailURL: URL(string: "https://i.imgur.com/G9L2rP2.jpg")
        ),
        Exercise(
            name: "Explosive Pull-Up",
            category: .plyometric, // Usando .plyometric
            equipment: "Barra fija",
            muscles: ["Espalda", "Bíceps"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Pullups.jpg")
        ),
        Exercise(
            name: "Jump Over Bench",
            category: .plyometric, // Usando .plyometric
            equipment: "Banco",
            muscles: ["Piernas", "Core"],
            thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/27/Box_Jump.jpg")
        )
    ]
}
