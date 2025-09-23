//
//  PopularWorkoutSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//

import SwiftUI

struct PopularWorkoutSectionView: View {
    var body: some View {
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
}

#Preview {
    PopularWorkoutSectionView()
}
