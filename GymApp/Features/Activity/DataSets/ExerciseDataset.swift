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
            category: "Pecho",
            equipment: "Barra y banco",
            muscles: ["Pectorales", "Tríceps", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://example.com/exercises/bench_press.jpg")
        ),
        Exercise(
            name: "Press de banca inclinado con mancuernas",
            category: "Pecho",
            equipment: "Mancuernas y banco inclinado",
            muscles: ["Pectorales superiores", "Tríceps", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://example.com/exercises/incline_dumbbell_press.jpg")
        ),
        Exercise(
            name: "Aperturas con mancuernas",
            category: "Pecho",
            equipment: "Mancuernas y banco plano",
            muscles: ["Pectorales", "Deltoides frontales"],
            thumbnailURL: URL(string: "https://example.com/exercises/dumbbell_fly.jpg")
        ),
        
        // MARK: - Espalda
        Exercise(
            name: "Dominadas",
            category: "Espalda",
            equipment: "Barra fija",
            muscles: ["Dorsales", "Bíceps", "Trapecios"],
            thumbnailURL: URL(string: "https://example.com/exercises/pullups.jpg")
        ),
        Exercise(
            name: "Remo con barra",
            category: "Espalda",
            equipment: "Barra",
            muscles: ["Dorsales", "Trapecios", "Bíceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/barbell_row.jpg")
        ),
        Exercise(
            name: "Jalón al pecho en polea",
            category: "Espalda",
            equipment: "Polea alta",
            muscles: ["Dorsales", "Bíceps", "Deltoides posteriores"],
            thumbnailURL: URL(string: "https://example.com/exercises/lat_pulldown.jpg")
        ),
        
        // MARK: - Piernas
        Exercise(
            name: "Sentadilla con barra",
            category: "Piernas",
            equipment: "Barra y rack",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://example.com/exercises/barbell_squat.jpg")
        ),
        Exercise(
            name: "Prensa de piernas",
            category: "Piernas",
            equipment: "Máquina de prensa",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://example.com/exercises/leg_press.jpg")
        ),
        Exercise(
            name: "Peso muerto",
            category: "Piernas",
            equipment: "Barra",
            muscles: ["Femorales", "Glúteos", "Espalda baja"],
            thumbnailURL: URL(string: "https://example.com/exercises/deadlift.jpg")
        ),
        Exercise(
            name: "Zancadas con mancuernas",
            category: "Piernas",
            equipment: "Mancuernas",
            muscles: ["Cuádriceps", "Glúteos", "Femorales"],
            thumbnailURL: URL(string: "https://example.com/exercises/dumbbell_lunge.jpg")
        ),
        Exercise(
            name: "Extensiones de piernas",
            category: "Piernas",
            equipment: "Máquina de extensiones",
            muscles: ["Cuádriceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/leg_extension.jpg")
        ),
        Exercise(
            name: "Curl de piernas acostado",
            category: "Piernas",
            equipment: "Máquina de femorales",
            muscles: ["Femorales"],
            thumbnailURL: URL(string: "https://example.com/exercises/leg_curl.jpg")
        ),
        Exercise(
            name: "Elevaciones de talones",
            category: "Piernas",
            equipment: "Máquina de gemelos o barra",
            muscles: ["Gemelos"],
            thumbnailURL: URL(string: "https://example.com/exercises/calf_raise.jpg")
        ),
        
        // MARK: - Hombros
        Exercise(
            name: "Press militar con barra",
            category: "Hombros",
            equipment: "Barra",
            muscles: ["Deltoides", "Tríceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/military_press.jpg")
        ),
        Exercise(
            name: "Elevaciones laterales",
            category: "Hombros",
            equipment: "Mancuernas",
            muscles: ["Deltoides laterales"],
            thumbnailURL: URL(string: "https://example.com/exercises/lateral_raise.jpg")
        ),
        Exercise(
            name: "Pájaros con mancuernas",
            category: "Hombros",
            equipment: "Mancuernas",
            muscles: ["Deltoides posteriores", "Trapecios"],
            thumbnailURL: URL(string: "https://example.com/exercises/rear_delt_fly.jpg")
        ),
        
        // MARK: - Brazos
        Exercise(
            name: "Curl de bíceps con barra",
            category: "Brazos",
            equipment: "Barra",
            muscles: ["Bíceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/barbell_bicep_curl.jpg")
        ),
        Exercise(
            name: "Curl de bíceps con mancuernas",
            category: "Brazos",
            equipment: "Mancuernas",
            muscles: ["Bíceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/dumbbell_bicep_curl.jpg")
        ),
        Exercise(
            name: "Extensiones de tríceps en polea",
            category: "Brazos",
            equipment: "Polea",
            muscles: ["Tríceps"],
            thumbnailURL: URL(string: "https://example.com/exercises/tricep_pushdown.jpg")
        ),
        Exercise(
            name: "Fondos en paralelas",
            category: "Brazos",
            equipment: "Paralelas",
            muscles: ["Tríceps", "Pectorales"],
            thumbnailURL: URL(string: "https://example.com/exercises/dips.jpg")
        ),
        
        // MARK: - Core
        Exercise(
            name: "Plancha abdominal",
            category: "Core",
            equipment: "Ninguno",
            muscles: ["Abdomen", "Espalda baja"],
            thumbnailURL: URL(string: "https://example.com/exercises/plank.jpg")
        ),
        Exercise(
            name: "Crunch abdominal",
            category: "Core",
            equipment: "Ninguno",
            muscles: ["Abdomen"],
            thumbnailURL: URL(string: "https://example.com/exercises/crunch.jpg")
        ),
        Exercise(
            name: "Elevaciones de piernas colgado",
            category: "Core",
            equipment: "Barra fija",
            muscles: ["Abdomen inferior", "Flexores de cadera"],
            thumbnailURL: URL(string: "https://example.com/exercises/hanging_leg_raise.jpg")
        ),
        Exercise(
            name: "Russian twists",
            category: "Core",
            equipment: "Mancuerna o balón medicinal",
            muscles: ["Oblicuos", "Abdomen"],
            thumbnailURL: URL(string: "https://example.com/exercises/russian_twist.jpg")
        )
    ]

    
    public static let hiitExercises: [Exercise] = [
            Exercise(
                name: "Burpees",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Cuerpo completo", "Pectorales", "Piernas"],
                thumbnailURL: URL(string: "https://example.com/exercises/burpees.jpg")
            ),
            Exercise(
                name: "Jumping Jacks",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Hombros", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/jumping_jacks.jpg")
            ),
            Exercise(
                name: "Mountain Climbers",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Abdomen", "Piernas", "Hombros"],
                thumbnailURL: URL(string: "https://example.com/exercises/mountain_climbers.jpg")
            ),
            Exercise(
                name: "High Knees",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/high_knees.jpg")
            ),
            Exercise(
                name: "Sprints en sitio",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/sprint_in_place.jpg")
            ),
            Exercise(
                name: "Skater Jumps",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Glúteos", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/skater_jumps.jpg")
            ),
            Exercise(
                name: "Jump Squats",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Glúteos"],
                thumbnailURL: URL(string: "https://example.com/exercises/jump_squats.jpg")
            ),
            Exercise(
                name: "Push-up to T Rotation",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Pectorales", "Hombros", "Core"],
                thumbnailURL: URL(string: "https://example.com/exercises/pushup_t_rotation.jpg")
            ),
            Exercise(
                name: "Plank Jack",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Core", "Hombros", "Piernas"],
                thumbnailURL: URL(string: "https://example.com/exercises/plank_jack.jpg")
            ),
            Exercise(
                name: "Jump Lunges",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Cuádriceps", "Glúteos", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/jump_lunges.jpg")
            ),
            Exercise(
                name: "Shadow Boxing",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Brazos", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/shadow_boxing.jpg")
            ),
            Exercise(
                name: "Kettlebell Swings",
                category: "HIIT",
                equipment: "Kettlebell",
                muscles: ["Glúteos", "Espalda baja", "Hombros"],
                thumbnailURL: URL(string: "https://example.com/exercises/kettlebell_swings.jpg")
            ),
            Exercise(
                name: "Battle Ropes",
                category: "HIIT",
                equipment: "Cuerdas de batalla",
                muscles: ["Brazos", "Hombros", "Core"],
                thumbnailURL: URL(string: "https://example.com/exercises/battle_ropes.jpg")
            ),
            Exercise(
                name: "Box Jump",
                category: "HIIT",
                equipment: "Caja pliométrica",
                muscles: ["Piernas", "Glúteos"],
                thumbnailURL: URL(string: "https://example.com/exercises/box_jump.jpg")
            ),
            Exercise(
                name: "Plank Shoulder Taps",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Core", "Hombros"],
                thumbnailURL: URL(string: "https://example.com/exercises/plank_taps.jpg")
            ),
            Exercise(
                name: "Jump Rope",
                category: "HIIT",
                equipment: "Cuerda para saltar",
                muscles: ["Piernas", "Cardio"],
                thumbnailURL: URL(string: "https://example.com/exercises/jump_rope.jpg")
            ),
            Exercise(
                name: "Side-to-Side Hops",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Core"],
                thumbnailURL: URL(string: "https://example.com/exercises/side_hops.jpg")
            ),
            Exercise(
                name: "Squat Thrust",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Core", "Pectorales"],
                thumbnailURL: URL(string: "https://example.com/exercises/squat_thrust.jpg")
            ),
            Exercise(
                name: "Bear Crawl",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Core", "Hombros", "Piernas"],
                thumbnailURL: URL(string: "https://example.com/exercises/bear_crawl.jpg")
            ),
            Exercise(
                name: "Jump Tuck",
                category: "HIIT",
                equipment: "Ninguno",
                muscles: ["Piernas", "Abdomen"],
                thumbnailURL: URL(string: "https://example.com/exercises/tuck_jump.jpg")
            )
        ]
    
    
    public static let plyometricExercises: [Exercise] = [
           Exercise(
               name: "Box Jump",
               category: "Pliométricos",
               equipment: "Caja pliométrica",
               muscles: ["Piernas", "Glúteos", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/box_jump.jpg")
           ),
           Exercise(
               name: "Broad Jump",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Glúteos", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/broad_jump.jpg")
           ),
           Exercise(
               name: "Depth Jump",
               category: "Pliométricos",
               equipment: "Caja o plataforma",
               muscles: ["Cuádriceps", "Glúteos", "Femorales"],
               thumbnailURL: URL(string: "https://example.com/exercises/depth_jump.jpg")
           ),
           Exercise(
               name: "Jump Squat",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/jump_squat.jpg")
           ),
           Exercise(
               name: "Lateral Bounds",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/lateral_bounds.jpg")
           ),
           Exercise(
               name: "Split Jump",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Cuádriceps", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/split_jump.jpg")
           ),
           Exercise(
               name: "Clapping Push-ups",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Pectorales", "Tríceps", "Hombros"],
               thumbnailURL: URL(string: "https://example.com/exercises/clapping_pushup.jpg")
           ),
           Exercise(
               name: "Medicine Ball Slam",
               category: "Pliométricos",
               equipment: "Balón medicinal",
               muscles: ["Hombros", "Espalda", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/medicine_ball_slam.jpg")
           ),
           Exercise(
               name: "Jumping Lunges",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/jumping_lunges.jpg")
           ),
           Exercise(
               name: "Single-Leg Hop",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Gemelos"],
               thumbnailURL: URL(string: "https://example.com/exercises/single_leg_hop.jpg")
           ),
           Exercise(
               name: "Bounding",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/bounding.jpg")
           ),
           Exercise(
               name: "Lateral Hurdle Jumps",
               category: "Pliométricos",
               equipment: "Vallas o conos",
               muscles: ["Piernas", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/lateral_hurdle_jump.jpg")
           ),
           Exercise(
               name: "Tuck Jump",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Piernas", "Abdomen"],
               thumbnailURL: URL(string: "https://example.com/exercises/tuck_jump.jpg")
           ),
           Exercise(
               name: "Jump to Box Lateral Step Down",
               category: "Pliométricos",
               equipment: "Caja pliométrica",
               muscles: ["Piernas", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/box_lateral_step.jpg")
           ),
           Exercise(
               name: "Depth Drop to Jump",
               category: "Pliométricos",
               equipment: "Caja o plataforma",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/depth_drop_jump.jpg")
           ),
           Exercise(
               name: "Burpee Jump",
               category: "Pliométricos",
               equipment: "Ninguno",
               muscles: ["Cuerpo completo"],
               thumbnailURL: URL(string: "https://example.com/exercises/burpee_jump.jpg")
           ),
           Exercise(
               name: "Explosive Step-Up",
               category: "Pliométricos",
               equipment: "Banco o caja",
               muscles: ["Piernas", "Glúteos"],
               thumbnailURL: URL(string: "https://example.com/exercises/explosive_stepup.jpg")
           ),
           Exercise(
               name: "Medicine Ball Chest Pass",
               category: "Pliométricos",
               equipment: "Balón medicinal",
               muscles: ["Pectorales", "Tríceps", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/medicine_ball_pass.jpg")
           ),
           Exercise(
               name: "Explosive Pull-Up",
               category: "Pliométricos",
               equipment: "Barra fija",
               muscles: ["Espalda", "Bíceps"],
               thumbnailURL: URL(string: "https://example.com/exercises/explosive_pullup.jpg")
           ),
           Exercise(
               name: "Jump Over Bench",
               category: "Pliométricos",
               equipment: "Banco",
               muscles: ["Piernas", "Core"],
               thumbnailURL: URL(string: "https://example.com/exercises/jump_over_bench.jpg")
           )
       ]
}
