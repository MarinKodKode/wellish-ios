//
//  RoutinePlans.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import SwiftUI

/// Represents a pre-made template routine
struct RoutineTemplate: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let description: String
    let imageName: String
    let estimatedDuration: Int // in minutes
    let difficulty: Difficulty
}

enum Difficulty: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

extension Difficulty {
    var color: Color {
        switch self {
        case .beginner: .fitnessSuccess
        case .intermediate: .energyFitnessOrange
        case .advanced: .errorFitnessRed
        }
    }
}

struct PlansView: View {
    @StateObject var vm: RoutineViewModel // Fetches saved routines

    // Pre-made templates
    private let templates: [RoutineTemplate] = [
        RoutineTemplate(
            name: "Full Body Gym",
            category: "Strength",
            description: "3-day split for full-body strength",
            imageName: "dumbbell.fill",
            estimatedDuration: 60,
            difficulty: .intermediate
        ),
        RoutineTemplate(
            name: "Beginner Run",
            category: "Cardio",
            description: "Couch to 5K starter plan",
            imageName: "figure.run",
            estimatedDuration: 30,
            difficulty: .beginner
        ),
        RoutineTemplate(
            name: "Isometric Flow",
            category: "Mobility",
            description: "Static holds for strength & control",
            imageName: "figure.yoga",
            estimatedDuration: 20,
            difficulty: .beginner
        ),
        RoutineTemplate(
            name: "Cycling HIIT",
            category: "Cardio",
            description: "High-intensity interval training",
            imageName: "bicycle",
            estimatedDuration: 45,
            difficulty: .advanced
        ),
        RoutineTemplate(
            name: "Upper Body Blast",
            category: "Strength",
            description: "Chest, back & arms focus",
            imageName: "figure.mixed-cardio",
            estimatedDuration: 50,
            difficulty: .intermediate
        )
    ]

    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Custom background
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Carousel of Templates
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recommended Templates")
                                .font(.title2.bold())
                                .foregroundColor(.fitnessTextPrimary)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(templates) { template in
                                        TemplateCard(template: template) {
                                            // Action: Apply template or preview
                                            print("Applied: \(template.name)")
                                            // You could: vm.applyTemplate(template)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }

                        // My Saved Routines
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("My Routines")
                                    .font(.title2.bold())
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                NavigationLink("See All", destination: AllRoutinesView(vm: vm))
                                    .font(.subheadline)
                                    .foregroundColor(.primaryFitnessBlue)
                            }
                            .padding(.horizontal)

                            if $vm.savedRoutines.isEmpty {
                                Text("No routines saved yet.")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(vm.savedRoutines) { routine in
                                    RoutineRowView(routine: routine)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitle("Plans")
        }
    }
}

// MARK: - Template Card (Carousel Item)

private struct TemplateCard: View {
    let template: RoutineTemplate
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icon & Category
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(Color.fitnessBackgroundSecondary)
                    .frame(width: 60, height: 60)
                Image(systemName: template.imageName)
                    .font(.title2)
                    .foregroundColor(.primaryFitnessBlue)
            }

            Text(template.name)
                .font(.headline)
                .foregroundColor(.fitnessTextPrimary)

            Text(template.description)
                .font(.caption)
                .foregroundColor(.fitnessTextSecondary)
                .lineLimit(2)

            HStack {
                Label("\(template.estimatedDuration)min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
                Spacer()
                Text(template.difficulty.rawValue)
                    .font(.caption)
                    .foregroundColor(template.difficulty.color)
            }
        }
        .padding()
        .frame(width: 180)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
        .onTapGesture(perform: action)
    }
}

// MARK: - Saved Routine Row

private struct RoutineRowView: View {
    let routine: Routine

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(.primaryFitnessBlue)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.fitnessTextPrimary)
                Text("\(routine.sets.count) exercises · \(routine.totalSeriesCount) series")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.fitnessTextSecondary)
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}

// MARK: - Detail View Stub

struct RoutineDetailView: View {
    let routine: Routine

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(routine.name)
                    .font(.title.bold())
                    .foregroundColor(.fitnessTextPrimary)

                if let category = routine.category, !category.isEmpty {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.primaryFitnessBlue)
                }

                if let description = routine.description, !description.isEmpty {
                    Text(description)
                        .foregroundColor(.fitnessTextSecondary)
                }

                // Metrics
                HStack {
                    VStack {
                        Text("\(routine.totalSeriesCount)")
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Sets")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    Spacer()
                    VStack {
                        Text("\(routine.totalReps)")
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Reps")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    Spacer()
                    VStack {
                        Text(String(format: "%.0fkg", routine.estimatedVolumeKg))
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Volume")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                }
                .padding()
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(12)

                // Tags
                if !routine.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(routine.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.primaryFitnessBlue.opacity(0.1))
                                    .foregroundColor(.primaryFitnessBlue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Exercises
                Text("Exercises")
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)
                    .padding(.top)

                ForEach(routine.sets) { set in
                    VStack(alignment: .leading) {
                        Text(set.exercise.name)
                            .font(.headline)
                            .foregroundColor(.fitnessTextPrimary)
                        Text("\(set.series.count) series")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    .padding()
                    .background(Color.fitnessBackgroundSecondary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color.fitnessBackgroundPrimary)
        .navigationTitle("Routine")
    }
}

// MARK: - All Routines List

private struct AllRoutinesView: View {
    @ObservedObject var vm: RoutineViewModel

    var body: some View {
        List {
            if vm.savedRoutines.isEmpty {
                Text("No routines yet.")
                    .foregroundColor(.fitnessTextSecondary)
            } else {
                ForEach(vm.savedRoutines) { routine in
                    RoutineRowView(routine: routine)
                }
            }
        }
        .background(Color.fitnessBackgroundPrimary)
        .navigationTitle("All Routines")
    }
}

// MARK: - Previews

struct PlansView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.light)

            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
