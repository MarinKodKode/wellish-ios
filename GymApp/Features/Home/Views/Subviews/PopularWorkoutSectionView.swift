//
//  PopularWorkoutSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//

import SwiftUI

struct PopularWorkoutSectionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            SectionBarTitle(title: "Rutinas Populares 🏆", icon: "arrow.right")
            ZStack {
                
                Image("background_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
                Color.fitnessBackgroundPrimary.opacity(0.8)
                
                VStack (alignment: .leading) {
                    Text("Burning Chest\nWorkout")
                        .font(.custom("Lemon", size: 28))
                        .foregroundColor(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    HStack (alignment: .center){
                        
                        RoutineStatisticsRowView(
                            size: 14,
                            gap : 8,
                            numberOfStats: 2,
                            alignTo: .leading
                        )
                        Spacer()
                        
                        Badge(label: "Intermediate")
                        
                    }
                    .frame(alignment: .leading)
                    .padding(.horizontal, 16)
                    
                }
            }
            .frame(height: 150)
            .cornerRadius(16)
            .padding(.horizontal , 14)
                
            
        }
    }
}

#Preview {
    PopularWorkoutSectionView()
}
