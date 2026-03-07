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
    @State private var showWorkoutTimer_true = true
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var vm = MainHomeViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(vm.pageTagIndex)
            
            MetricsView(showWorkoutTimer: $showWorkoutTimer)
                .tabItem {
                    Label("Activity", systemImage: "figure.walk")
                }
                .tag(vm.pageTagIndex)
            PlansView(vm: GymActivityViewModel(), plansVM: PlansViewViewModel())
                .tabItem {
                    Label("Plans", systemImage: "clipboard")
                }
                .tag(vm.pageTagIndex)
                .environmentObject(vm)
            ProfileView(showWorkoutTimer: $showWorkoutTimer_true)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(vm.pageTagIndex)
        }
        .accentColor(.blue)
    }
}


