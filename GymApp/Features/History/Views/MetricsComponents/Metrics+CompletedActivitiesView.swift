//
//  Metrics+CompletedActivitiesView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 31/10/25.
//

import SwiftUI

struct Metrics_CompletedActivitiesView: View {
    
    let title : String

    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                }
                Spacer()
            }
            VStack(spacing: 16) {
                ForEach(1..<5) {  _ in
                    CompletedActivityCard()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct CompletedActivityCard : View {
    var body: some View {
        
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: "https://www.menzig.fit/images/a/0000/52-h1.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                    .overlay(
                        Image(systemName: "dumbbell.fill")
                            .foregroundColor(.fitnessTextSecondary)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Rutina de pecho")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                    
                    Spacer()
                    
                    Text("Intermedio")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.energyOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.fitnessSuccess.opacity(0.2))
                        .cornerRadius(8)
                }
                
                HStack(spacing: 16) {
                   
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        Text("59 mins.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        Text("350 cal.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                }
                
                HStack(spacing: 8) {
                    ProgressView(value: 46)
                        .progressViewStyle(
                            LinearProgressViewStyle(
                                tint: progressColor(for: 45)
                            )
                        )
                        .scaleEffect(x: 1, y: 2)
                    
                    Text("\(Int(0.3 * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    .backgroundPrimary.opacity(0.4),
                    .fitnessInfo.opacity(0.3),
                    .backgroundPrimary.opacity(0.4),
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
        )
        
    }
}
