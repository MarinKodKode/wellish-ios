//
//  Profile_Component_Achievement_Badge.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 02/12/25.
//

import Foundation
import SwiftUI

struct AchievementBadge : View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(color)
                .frame(width: 80, height: 80)
                .background(Color.fitnessBackgroundPrimary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.fitnessTextPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }
        }
        .padding(12)
        .frame(width: 100)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
}


#Preview {
    AchievementBadge(
        icon: "trophy",
        title: "Week Warrior",
        subtitle: "7-day streak",
        color: .energyFitnessOrange
    )
}

