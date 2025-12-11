//
//  SummaryCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 11/12/25.
//

import Foundation
import SwiftUI

struct SummaryStatsCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ZStack {
                    Image(systemName: icon)
                        .font(.system(size: geometry.size.height * 1.5))
                        .foregroundColor(.white.opacity(0.15))
                        .offset(x: geometry.size.width * 0.3, y: -geometry.size.height * 0.1)
                        .blur(radius: 3)
                }
                
                // Contenido
                HStack(spacing: 16) {
                    // Icono principal
                    Image(systemName: icon)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Información
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(value)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .cornerRadius(20)
        }
        .frame(height: UIScreen.main.bounds.height * 0.12)
    }
}

#Preview {
    ZStack {
        Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea()
        
        
    }
}

struct SummarySectionView : View {
    var body: some View {
        VStack(spacing: 16) {
            // Rutinas hechas
            SummaryStatsCard(
                icon: "dumbbell.fill",
                title: "Rutinas completadas",
                value: "42",
                subtitle: "Este mes • +12 vs. anterior",
                gradientColors: [
                    Color(red: 0.4, green: 0.7, blue: 1.0),
                    Color(red: 0.6, green: 0.8, blue: 1.0)
                ]
            )
            
            // Calorías quemadas
            SummaryStatsCard(
                icon: "flame.fill",
                title: "Calorías quemadas",
                value: "12,450",
                subtitle: "Total • Promedio 415/día",
                gradientColors: [
                    Color(red: 1.0, green: 0.5, blue: 0.3),
                    Color(red: 1.0, green: 0.7, blue: 0.4)
                ]
            )
            
            // Tiempo total
            SummaryStatsCard(
                icon: "clock.fill",
                title: "Tiempo entrenando",
                value: "28h 30m",
                subtitle: "Este mes • 54 min/sesión",
                gradientColors: [
                    Color(red: 0.5, green: 0.8, blue: 0.6),
                    Color(red: 0.6, green: 0.9, blue: 0.7)
                ]
            )
        }
        .padding(.horizontal, 20)
    }
}
