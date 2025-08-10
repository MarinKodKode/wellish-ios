//
//  MainTestHomeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

// MARK: - Main Home View
struct MainHomeView: View {
    @State private var selectedBodyPart = "Full Body"
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Challenge Card
                        challengeCardView
                        
                        // Body Parts Filter
                        bodyPartsFilterView
                        
                        // Suggested Workouts
                        suggestedWorkoutsView
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=faces")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Welcome Back")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    Text("Alina")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
    }
    
    private var challengeCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
            
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1594737625785-a6cbdabd333c?w=200&h=200&fit=crop")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 100, height: 120)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("We have new challenge!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("200")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Step")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.bottom, 4)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Join Challenge")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.8, green: 0.95, blue: 0.3))
                            .cornerRadius(20)
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .frame(height: 150)
    }
    
    private var bodyPartsFilterView: some View {
        HStack(spacing: 12) {
            ForEach(bodyParts, id: \.self) { bodyPart in
                Button(action: {
                    selectedBodyPart = bodyPart
                }) {
                    Text(bodyPart)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedBodyPart == bodyPart ? .black : .white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            selectedBodyPart == bodyPart ?
                            Color(red: 0.8, green: 0.95, blue: 0.3) :
                                Color(red: 0.15, green: 0.15, blue: 0.15)
                        )
                        .cornerRadius(20)
                }
            }
            Spacer()
        }
    }
    
    private var suggestedWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Suggested Workout")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                }
            }
            
            VStack(spacing: 12) {
                ForEach(workouts, id: \.id) { workout in
                    workoutRowView(workout: workout)
                }
            }
        }
    }
    
    private func workoutRowView(workout: WorkoutItem) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: workout.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text("\(workout.tutorials)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Text("Tutorials")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(workout.duration)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Text("Minutes")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(12)
    }
}

#Preview {
    MainHomeView()
}
