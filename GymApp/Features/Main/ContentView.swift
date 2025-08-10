//
//  ContentView.swift
//  GymApp
//
//  Created by Manuel Alejandro Hernandez Marín on 18/07/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var onboardingService = OnboardingService()
    @StateObject private var authenticationService = AuthenticationService()
    @State private var navigationPath = NavigationPath()
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $navigationRouter.path) {
            Group {
                if onboardingService.shouldShowOnboarding {
                    OnboardingView()
                        .environmentObject(onboardingService)
                } else {
                    authenticationFlow
                }
            }
            .animation(.easeInOut(duration: 0.3), value: onboardingService.shouldShowOnboarding)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signup:
                    SignUpView()
                        .environmentObject(navigationRouter)
                case .signin:
                    SignInView()
                        .environmentObject(navigationRouter)
                default :
                    SignInView()
                }
            }
        }
    }
    
    @ViewBuilder
    private var authenticationFlow: some View {

        switch authenticationService.authenticationState {
        case .loading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
        case .authenticated:
            MainTabViewContainer(navigationPath: $navigationPath)
                .environmentObject(authenticationService)
            
        case .unauthenticated:
            WelcomeView()
                .environmentObject(navigationRouter)
                .environmentObject(authenticationService)
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
