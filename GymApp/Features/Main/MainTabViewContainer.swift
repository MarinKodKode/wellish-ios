//
//  MainTabViewContainer.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MainTabViewContainer: View {
    
    @Binding var navigationPath : NavigationPath
    @State private var selectedTab = 0
    @State private var showWorkoutTimer = false
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
//        NavigationStack(path: $navigationRouter.path) {
            TabView(selection: $selectedTab) {
                MainHomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                MetricsView(showWorkoutTimer: $showWorkoutTimer)
                    .tabItem {
                        Label("Activity", systemImage: "figure.walk")
                    }
                    .tag(1)
                
                Text("Profile Picture")
                    .tabItem {
                        Label("Plans", systemImage: "clipboard")
                    }
                    .tag(2)
                
                Text("Profile Picture")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .preferredColorScheme(.dark)
//        }
//        .navigationDestination(for: AppRoute.self) { route in
//            switch route {
//            case .maintab :
//                MetricsView(showWorkoutTimer: $showWorkoutTimer)
//            case .signup :
//                SignUpView()
//            case .signin :
//                SignInView()
//            default :
//                MetricsView(showWorkoutTimer: $showWorkoutTimer)
//            }
//        }
    }
}
