//
//  CategoriesSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//

import SwiftUI

public struct  CategoriesSectionView :  View {
        
    public var body : some View {
        VStack(alignment: .leading, spacing: 16) {
          
            SectionBarTitle(title: "Categorias", icon: "arrow-right")
            
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.red.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
//
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Home\nWorkout")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.leading)
//                        
//                        Text("12 Exercise")
//                            .font(.system(size: 12, weight: .medium))
//                            .foregroundColor(.white.opacity(0.8))
//                        
//                        Spacer()
//                        
//                        HStack {
//                            Image(systemName: "plus")
//                                .foregroundColor(.black)
//                                .font(.system(size: 10, weight: .bold))
//                                .frame(width: 20, height: 20)
//                                .background(Color(red: 0.8, green: 0.95, blue: 0.3))
//                                .clipShape(Circle())
//                            
//                            Text("4.9")
//                                .font(.system(size: 12, weight: .semibold))
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                        }
//                    }
//                    .padding(16)
//                    
//                    // Add woman silhouette
//                    VStack {
//                        HStack {
//                            Spacer()
//                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=80&h=120&fit=crop&crop=faces")) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                            } placeholder: {
//                                Rectangle()
//                                    .fill(Color.clear)
//                            }
//                            .frame(width: 60, height: 90)
//                            .cornerRadius(8)
//                        }
//                        Spacer()
//                    }
//                    .padding(8)
                }
                .frame(width: 160, height: 140)
//                
//                // Hand Exercise
//                ZStack {
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
//                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Hand\nExercise")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.leading)
//                        
//                        Text("12 Exercise")
//                            .font(.system(size: 12, weight: .medium))
//                            .foregroundColor(.gray)
//                        
//                        Spacer()
//                        
//                        HStack {
//                            Image(systemName: "star.fill")
//                                .foregroundColor(Color(red: 0.8, green: 0.95, blue: 0.3))
//                                .font(.system(size: 10))
//                            
//                            Text("4.9")
//                                .font(.system(size: 12, weight: .semibold))
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                        }
//                    }
//                    .padding(16)
//                    
//                    // Add person silhouette
//                    VStack {
//                        HStack {
//                            Spacer()
//                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=80&h=120&fit=crop&crop=faces")) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                            } placeholder: {
//                                Rectangle()
//                                    .fill(Color.clear)
//                            }
//                            .frame(width: 60, height: 90)
//                            .cornerRadius(8)
//                        }
//                        Spacer()
//                    }
//                    .padding(8)
//                }
//                .frame(width: 160, height: 140)
            }
        }

    }
}


#Preview {
    CategoriesSectionView()
}
