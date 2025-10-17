//
//  TodayWorkoutsView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//

import SwiftUI

struct TodayWorkoutView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
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
                    
                    RoutineStatisticsRowView(size: 14, gap : 24)
                }
            }
            .frame(height: 250)
            .cornerRadius(12)
            .padding(.horizontal, 12)
            .onTapGesture {
                navigationRouter.goTo(.todayWorkout)
            }
        }
        
    }
}

#Preview {
    TodayWorkoutView()
}
