//
//  PlanCreator+ButtonSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {

    
    var PlanCreatorButtonsSection : some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    await viewModel.savePlan()
                    dismiss()
                }
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.title3)
                    Text("Guardar plan")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.green, Color.green.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.green.opacity(0.3), radius: 10, y: 5)
            }
            
            Button {
                // Share plan
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    Text("Compartir plan")
                        .font(.headline)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "1E293B").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .padding()
        .background(
            Color(hex: "0F172A").opacity(0.95)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea()
        )
    }
    
    
}
