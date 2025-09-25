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
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 24) {
                            HomeHeaderView()
                            ChallengeSectionSubview(challenge: challenges)
                            TodayWorkoutView()
                            CategoriesSectionView()
                            PopularWorkoutSectionView()
                        }                    }
                    .clipped()
                }
            }
            .navigationBarHidden(true)
            .statusBarHidden(false)
        }
    

    
//    
//    private var trySomethingNewView: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text("Try Something New")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                
//                Spacer()
//                
//                Button(action: {}) {
//                    Text("See more")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
//                    Image(systemName: "arrow.right")
//                        .font(.system(size: 12, weight: .medium))
//                        .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
//                }
//            }
//            
//            VStack(spacing: 12) {
//                // Yoga Class
//                ZStack {
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.2)]),
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                    
//                    HStack {
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 12))
//                                Text("5.0")
//                                    .font(.system(size: 14, weight: .semibold))
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 8)
//                                    .padding(.vertical, 4)
//                                    .background(Color.pink)
//                                    .cornerRadius(12)
//                            }
//                            
//                            Text("Yoga Class")
//                                .font(.system(size: 22, weight: .bold))
//                                .foregroundColor(.white)
//                            
//                            Text("06:00 am – 8:00 am")
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.white.opacity(0.8))
//                            
//                            HStack(spacing: 12) {
//                                Text("Large hall")
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.white.opacity(0.8))
//                                Text("Beginner")
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        VStack {
//                            Button(action: {}) {
//                                Image(systemName: "plus")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .bold))
//                                    .frame(width: 40, height: 40)
//                                    .background(Color.pink)
//                                    .clipShape(Circle())
//                            }
//                            Spacer()
//                        }
//                        
//                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1506629905607-21d00c92e5bb?w=120&h=100&fit=crop")) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                        } placeholder: {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.3))
//                        }
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(12)
//                    }
//                    .padding(16)
//                }
//                .frame(height: 120)
//                
//                // Cardio
//                ZStack {
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)]),
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                    
//                    HStack {
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 12))
//                                Text("4.7")
//                                    .font(.system(size: 14, weight: .semibold))
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 8)
//                                    .padding(.vertical, 4)
//                                    .background(Color.pink)
//                                    .cornerRadius(12)
//                            }
//                            
//                            Text("Cardio")
//                                .font(.system(size: 22, weight: .bold))
//                                .foregroundColor(.white)
//                            
//                            Text("09:00 am – 09:45 am")
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.white.opacity(0.8))
//                            
//                            HStack(spacing: 12) {
//                                Text("Central hall")
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.white.opacity(0.8))
//                                Text("Beginner")
//                                    .font(.system(size: 12, weight: .medium))
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        VStack {
//                            Button(action: {}) {
//                                Image(systemName: "plus")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .bold))
//                                    .frame(width: 40, height: 40)
//                                    .background(Color.pink)
//                                    .clipShape(Circle())
//                            }
//                            Spacer()
//                        }
//                        
//                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=120&h=100&fit=crop")) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                        } placeholder: {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.3))
//                        }
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(12)
//                    }
//                    .padding(16)
//                }
//                .frame(height: 120)
//            }
//        }
//    }
//    
//
//    
//    @ViewBuilder
//    private var backgroundChallengeView : some View {
//        
//        var imageUrl : String = ""
//        
//        ZStack {
//            AsyncImage(url: URL(string: imageUrl)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } placeholder: {
//                Rectangle()
//                    .fill(Color.white.opacity(0.2))
//            }
//            .frame(width: 90, height: 120)
//            .clipShape(RoundedRectangle(cornerRadius: 16))
//            
//            // Subtle overlay gradient
//            RoundedRectangle(cornerRadius: 16)
//                .fill(
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.1)]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .frame(width: 90, height: 120)
//        }
//    }
}

#Preview {
    MainHomeView()
}
