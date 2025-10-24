//
//  ProfileView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 13/08/25.
//


import SwiftUI

struct ProfileView: View {
    @Binding var showWorkoutTimer: Bool

    // Sample user data
    @State private var username = "Zayn Pradipta"
    @State private var email = "zayn.pradipta@example.com"
    @State private var bio = "Lifting weights & chasing progress 🏋️‍♂️"
    @State private var routinesCompleted = 42
    @State private var currentStreak = 14
    @State private var totalWorkoutTimeHours = 32

    var body: some View {
        NavigationView {
            ZStack {
                // Custom background
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        profileHeaderView
                        
                        achievementsSection

                        statsSection

                        quickActionsSection

                        savedRoutinesSection

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
        }
    }

    // MARK: - Profile Header
    private var profileHeaderView: some View {
        VStack(alignment: .center, spacing: 16) {
            // Avatar
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=faces")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.fitnessBackgroundSecondary)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.primaryFitnessBlue, lineWidth: 2)
            )

            // Name & Bio
            VStack(alignment: .center, spacing: 4) {
                Text(username)
                    .font(.title2.bold())
                    .foregroundColor(.fitnessTextPrimary)

                if !bio.isEmpty {
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // Email
            Text(email)
                .font(.caption)
                .foregroundColor(.fitnessTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    // MARK: - Stats Cards
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Stats")
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)

                Spacer()

                Text("Last 30 days")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    icon: "checkmark.circle.fill",
                    label: "Routines",
                    value: "\(routinesCompleted)",
                    iconColor: .fitnessSuccess
                )

                StatCard(
                    icon: "flame.fill",
                    label: "Streak",
                    value: "\(currentStreak)d",
                    iconColor: .energyFitnessOrange
                )

                StatCard(
                    icon: "clock.fill",
                    label: "Workout Time",
                    value: "\(totalWorkoutTimeHours)h",
                    iconColor: .primaryFitnessBlue
                )
            }
        }
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)

            VStack(spacing: 12) {
                ActionRow(icon: "person.circle", label: "Edit Profile", action: {})
                ActionRow(icon: "gear", label: "Settings", action: {})
                ActionRow(icon: "bell", label: "Notifications", action: {})
                ActionRow(icon: "heart", label: "Favorites", action: {})
                ActionRow(icon: "doc.text", label: "Saved Routines", action: {})
            }
        }
    }

    // MARK: - Saved Routines Preview
    private var savedRoutinesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Saved Routines")
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)

                Spacer()

                Button("See All") {
                    // Navigate to routines list
                }
                .font(.caption)
                .foregroundColor(.primaryFitnessBlue)
            }

            if !routines.isEmpty {
                ForEach(Array(routines.prefix(3).enumerated()), id: \.element.id) { index, routine in
                    NavigationLink(destination: PlansRoutineDetailView(routine: routine)) {
                        RoutinePreviewRow(routine: routine)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Text("No routines saved yet.")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.fitnessBackgroundSecondary)
                    .cornerRadius(12)
            }
        }
    }

    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    AchievementBadge(
                        icon: "trophy",
                        title: "Week Warrior",
                        subtitle: "7-day streak",
                        color: .energyFitnessOrange
                    )
                    AchievementBadge(
                        icon: "flame",
                        title: "Fire Starter",
                        subtitle: "10 routines",
                        color: .errorFitnessRed
                    )
                    AchievementBadge(
                        icon: "dumbbell",
                        title: "Strength Pro",
                        subtitle: "50 workouts",
                        color: .primaryFitnessBlue
                    )
                    AchievementBadge(
                        icon: "star",
                        title: "Perfect Week",
                        subtitle: "All plans done",
                        color: .premiumFitnessPurple
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Subviews

/// Reusable stat card (like in MetricsView)
private struct StatCard: View {
    let icon: String
    let label: String
    let value: String
    let iconColor: Color

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                Spacer()
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)

                Text(value)
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
}

/// Action row with icon and label
private struct ActionRow: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryFitnessBlue)

                Text(label)
                    .font(.body)
                    .foregroundColor(.fitnessTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.fitnessTextSecondary)
            }
            .padding(12)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(12)
        }
    }
}

/// Preview row for a saved routine
private struct RoutinePreviewRow: View {
    let routine: GymActivity

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(.primaryFitnessBlue)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.fitnessTextPrimary)
                HStack {
                    Text("\(routine.sets.count) exercises")
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                    Text(routine.formattedDuration)
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.fitnessTextSecondary)
        }
        .padding(12)
        .background(Color.fitnessBackgroundSecondary.opacity(0.7))
        .cornerRadius(12)
    }
}

/// Achievement badge
private struct AchievementBadge: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(Color.fitnessBackgroundPrimary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.fitnessTextPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }
        }
        .padding(12)
        .frame(width: 100)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
}


//MARK: - Previews

struct ProfileView_Prefixes_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var showWorkoutTimer: Bool = false
        
        ProfileView(showWorkoutTimer: $showWorkoutTimer)
            .preferredColorScheme(.dark)
        
        ProfileView(showWorkoutTimer: $showWorkoutTimer)
            .preferredColorScheme(.light)
    }
}
