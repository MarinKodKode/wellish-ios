//
//  ExercisePickerView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

struct ExercisePickerView: View {
    var onSelect: (Exercise) -> Void

    private let library: [Exercise] = [
        Exercise(name: "Bench Press", category: "Chest", equipment: "Barbell", muscles: ["Chest","Triceps"]),
        Exercise(name: "Squat", category: "Legs", equipment: "Barbell", muscles: ["Quadriceps","Glutes"]),
        Exercise(name: "Deadlift", category: "Back", equipment: "Barbell", muscles: ["Back","Hamstrings"]),
        Exercise(name: "Overhead Press", category: "Shoulders", equipment: "Barbell", muscles: ["Deltoids"])
    ]

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                
                List(library) { ex in
                    Button(action: {
                        onSelect(ex)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "dumbbell")
                                .font(.title2)
                                .foregroundColor(.primaryFitnessBlue)
                                .frame(width: 40, height: 40)
                                .background(Color.primaryFitnessBlue.opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ex.name)
                                    .font(.headline)
                                    .foregroundColor(.fitnessTextPrimary)
                                
                                if let category = ex.category {
                                    Text(category)
                                        .font(.caption)
                                        .foregroundColor(.fitnessTextSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.fitnessTextSecondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.fitnessBackgroundSecondary)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Choose Exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primaryFitnessBlue)
                }
            }
        }
    }
}
