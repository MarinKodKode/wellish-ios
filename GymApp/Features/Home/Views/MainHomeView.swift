//
//  MainTestHomeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MainHomeView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 36) {
                        HomeHeaderView()
                        ChallengeSectionSubview(challenge: challenges)
                        TodayWorkoutView()
                        CategoriesSectionView()
                        PopularWorkoutSectionView()
                        TrySomethingNewSectionView()
                            .padding(.bottom, 30)
                    }
                }
                .clipped()
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden(false)
    }
}

#Preview {
    MainHomeView()
}
