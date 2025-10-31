//
//  Metrics+StatisticsCards.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/10/25.
//

import SwiftUI

struct Metrics_StatisticsCard : View {
    
    let title : String
    
    init(title: String) {
        self.title = title
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
            }
            .padding(.horizontal, 16)
            
            HStack {
                StatisticCardWidget(
                    icon: "flame",
                    label: "Calorias",
                    unit: "Kcal",
                    statisticValue: "1200",
                    color: .energyFitnessOrange
                )
                
                Spacer()
                
                StatisticCardWidget(
                    icon: "clock",
                    label: "Tiempo",
                    unit: "Horas",
                    statisticValue: "52.5",
                    color: .primaryBlue
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    Metrics_StatisticsCard(title: "Tus metricas")
}


struct StatisticCardWidget : View {
    
    var icon , label, unit, statisticValue: String
    var color : Color
    
    init(
        icon: String,
        label: String,
        unit: String,
        statisticValue: String,
        color : Color
    ) {
        self.icon = icon
        self.label = label
        self.unit = unit
        self.statisticValue = statisticValue
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(label)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.fitnessTextPrimary)
                        Spacer()
                    }
                    
                    HStack(alignment: .bottom, spacing: 2) {
                        Text(statisticValue)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.fitnessTextPrimary)
                        Text(unit)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                            .padding(.bottom, 2)
                    }
                }
            }
            .padding(16)
            .frame(width: UIScreen.screenWidth * 0.45)
            .frame(height: 120)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [color.opacity(0.4), .fitnessInfo.opacity(0.3)]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
        }
    }
}
