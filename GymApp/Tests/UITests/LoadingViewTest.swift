//
//  LoadingViewtest.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import Foundation
import SwiftUI

struct LoadingTestView: View {
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                VStack(spacing: 20) {
                    Button("Test Loading (2 seconds)") {
                        simulateLoading()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Test Custom Animation") {
                        simulateLoadingWithCustomText()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button("Test Simple ProgressView") {
                        simulateLoadingWithSimpleProgress()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Loading Demo")
        }
        .showLoadingView(isLoading: isLoading)
    }
    
    private func simulateLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func simulateLoadingWithCustomText() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func simulateLoadingWithSimpleProgress() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}

// MARK: - Preview
struct LoadingTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingTestView()
            .preferredColorScheme(.dark)
    }
}
