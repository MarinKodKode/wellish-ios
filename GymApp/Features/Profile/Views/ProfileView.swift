//
//  ProfileView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 13/08/25.
//


import SwiftUI

struct ProfileView: View {
    
    @Binding var showWorkoutTimer: Bool
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        ProfileView_Header_Section()
                        
                        Profile_Achievements()
                        
                        statsSection
                        
                        quickActionsSection
                        
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationBarTitle("Perfil")
            .toolbarTitleDisplayMode(.inline)
        }
        .navigationBarHidden(true)
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
                Text(vm.username)
                    .font(.title2.bold())
                    .foregroundColor(.fitnessTextPrimary)
                
                if !vm.bio.isEmpty {
                    Text(vm.bio)
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Email
            Text(vm.email)
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
                    value: "\(vm.routinesCompleted)",
                    iconColor: .fitnessSuccess
                )
                
                StatCard(
                    icon: "flame.fill",
                    label: "Streak",
                    value: "\(vm.currentStreak)d",
                    iconColor: .energyFitnessOrange
                )
                
                StatCard(
                    icon: "clock.fill",
                    label: "Workout Time",
                    value: "\(vm.totalWorkoutTimeHours)h",
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
                ActionRow(
                    icon : "rectangle.portrait.and.arrow.forward",
                    label : "Cerrar sesión",
                    action: {
                        vm.onTap_CloseSession()
                    })
            }
        }
    }
    
    // MARK: - Achievements
    
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
