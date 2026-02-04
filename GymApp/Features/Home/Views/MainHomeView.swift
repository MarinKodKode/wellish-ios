//
//  MainTestHomeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MainHomeView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    let vm = PlanTrackerCurrentDayViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                ScrollView(.vertical) {
                    
                    HomeHeaderView()
                    
                    ChallengesSection()
                    
                    TodayWorkoutView()
                    
                    Spacer()
                    
//                    CategoriesSectionView()
                    
                    
//                    PopularWorkoutSectionView()
                    
//                    TrySomethingNewSectionView()
                        
                }
                .onAppear{
                    print("\(SessionDataManager.shared.photoIdentifier)")
                }
                .scrollIndicators(.hidden)
                .simultaneousGesture(DragGesture().onChanged({ _ in }))
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden(false)
    }
}

#Preview {
    MainHomeView()
}
