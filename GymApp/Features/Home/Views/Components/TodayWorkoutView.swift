//
//  TodayWorkoutsView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//

import SwiftUI

struct TodayWorkoutView: View {
    var body: some View {
        VStack() {
            
            SectionBarTitle(title: "La rutina de hoy 🔥", icon: "arrow.right")
            
            ZStack {
               
                Image("background_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            
                Color.black.opacity(0.4)
                
                VStack(spacing : 12) {
                    
                    Text("Upper Body\nWorkout")
                        .font(.custom("Lemon", size: 40))
                        .foregroundColor(.fitnessTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing : 24) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            Text("90min")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            Text("1,200kcal")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "dumbbell")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            Text("90min")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                            }
            .frame(height: 250)
            
            .cornerRadius(12)
            
        }
    }
}

#Preview {
    TodayWorkoutView()
}
