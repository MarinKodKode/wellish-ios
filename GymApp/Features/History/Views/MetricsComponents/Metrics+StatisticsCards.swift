//
//  Metrics+StatisticsCards.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/10/25.
//

import SwiftUI

struct Metrics_StatisticsCards: View {
    
    var selectedTimeframe = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(StringConstants.activityOverview)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Menu {
                    Button(StringConstants.today) {
                        selectedTimeframe = "Today"
                    }
                    Button(StringConstants.weekly) {
                        selectedTimeframe = "Weekly"
                    }
                    Button(StringConstants.monthly) {
                        selectedTimeframe = "Monthly"
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimeframe)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.fitnessTextPrimary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.fitnessBackgroundSecondary)
                    .cornerRadius(8)
                }
            }
            
            HStack(spacing: 12) {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.fitnessPrimary)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(StringConstants.calories)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.fitnessTextPrimary)
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("8,3")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                            Text("k")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                            Text(StringConstants.burned)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.fitnessTextSecondary)
                                .padding(.bottom, 2)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(16)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(.fitnessWarning)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(StringConstants.time)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.fitnessTextPrimary)
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("2 h 25")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                            Text(StringConstants.minutes)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.fitnessTextSecondary)
                                .padding(.bottom, 2)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(16)
            }
        }
    }
}

#Preview {
    Metrics_StatisticsCards()
}
