//
//  MainTestHomeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

// MARK: - Main Home View
struct MainHomeView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary 
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Challenge Card
                        ChallengeSectionSubview(challenge: challenges)
                        
                        // Today Workouts
                        todayWorkoutsView
                        
                        // Try Something New
                        trySomethingNewView
                        
                        // Categories (Popular Exercises)
                        categoriesView
                        
                        // Popular Workouts (Our Collection)
                        popularWorkoutsView
                    }

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
    
    private var todayWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today Workouts")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("(17)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.4, green: 0.5, blue: 0.2), Color(red: 0.2, green: 0.3, blue: 0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("90min")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("1,200kcal")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text("Upper Body\nWorkout")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150&h=150&fit=crop&crop=faces")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 100, height: 130)
                    .cornerRadius(12)
                }
                .padding(20)
            }
            .frame(height: 150)
        }
    }
    
    private var trySomethingNewView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Try Something New")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                }
            }
            
            VStack(spacing: 12) {
                // Yoga Class
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("5.0")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.pink)
                                    .cornerRadius(12)
                            }
                            
                            Text("Yoga Class")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("06:00 am – 8:00 am")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Text("Large hall")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Beginner")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(Color.pink)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1506629905607-21d00c92e5bb?w=120&h=100&fit=crop")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 120)
                
                // Cardio
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("4.7")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.pink)
                                    .cornerRadius(12)
                            }
                            
                            Text("Cardio")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("09:00 am – 09:45 am")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Text("Central hall")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Beginner")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(Color.pink)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=120&h=100&fit=crop")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 120)
            }
        }
    }
    
    // MARK: - Categories (Popular Exercises)
    private var categoriesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                }
            }
            
            HStack(spacing: 12) {
                // Home Workout
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.red.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Home\nWorkout")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("12 Exercise")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: 20, height: 20)
                                .background(Color(red: 0.8, green: 0.95, blue: 0.3))
                                .clipShape(Circle())
                            
                            Text("4.9")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(16)
                    
                    // Add woman silhouette
                    VStack {
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=80&h=120&fit=crop&crop=faces")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.clear)
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                .frame(width: 160, height: 140)
                
                // Hand Exercise
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hand\nExercise")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("12 Exercise")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
                                .font(.system(size: 10))
                            
                            Text("4.9")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(16)
                    
                    // Add person silhouette
                    VStack {
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=80&h=120&fit=crop&crop=faces")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.clear)
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                .frame(width: 160, height: 140)
            }
        }
    }
    
    // MARK: - Popular Workouts (Our Collection)
    private var popularWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Workouts")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // Chest & abdominal exercises
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.yellow.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chest & abdominal\nexercises")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "dumbbell")
                                    .foregroundColor(.black.opacity(0.7))
                                    .font(.system(size: 12))
                                Text("12 Exercise")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop&crop=faces")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 100)
                
                // Back & shoulder exercises
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.4), Color.blue.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Back & shoulder\nexercises")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "dumbbell")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 12))
                                Text("12 Exercise")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=100&h=100&fit=crop&crop=faces")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 100)
            }
        }
    }
    
    @ViewBuilder
    private var backgroundChallengeView : some View {
        
        var imageUrl : String = ""
        
        ZStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
            }
            .frame(width: 90, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Subtle overlay gradient
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 90, height: 120)
        }
    }
}

#Preview {
    MainHomeView()
}
