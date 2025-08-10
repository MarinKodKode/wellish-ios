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
