//
//  Metrics.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MetricsView: View {
    @Binding var showWorkoutTimer: Bool
    @State private var selectedTimeframe = "Today"
    @State private var selectedCalorieTimeframe = "Weekly"
    @State private var isLoading : Bool = true
    @EnvironmentObject private var navigatorRouter : NavigationRouter

    let plans = PlanDataset().getPlans()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        activityCardsView
                        caloriesChartView
                        todayPlanView
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitle(StringConstants.metricsTitle)
        }
        .navigationBarHidden(true)
    }
    
   
    
    private var caloriesChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.fitnessWarning)
                    Text(StringConstants.calories)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                }
                
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
                        Text(selectedCalorieTimeframe)
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
            
            // Chart Container
            VStack(spacing: 16) {
                // Chart
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(activityData.caloriesData.enumerated()), id: \.offset) { index, data in
                        VStack(spacing: 4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                                    .frame(height: 120)
                                
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(data.day == "Thu" ?
                                              LinearGradient(colors: [.fitnessWarning, .fitnessWarning.opacity(0.8)], startPoint: .top, endPoint: .bottom) :
                                              LinearGradient(colors: [.fitnessPrimary, .fitnessPrimary.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                                        .frame(height: CGFloat(data.calories) / 10)
                                }
                            }
                            .frame(width: 32)
                            
                            Text(data.day)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(data.day == "Thu" ? .fitnessWarning : .fitnessTextSecondary)
                        }
                    }
                }
                
                // Highlight current day calories
                if let todayData = activityData.caloriesData.first(where: { $0.day == "Thu" }) {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            Text("\(todayData.calories) Kcal")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [.fitnessWarning, .fitnessWarning.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    private var todayPlanView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16))
                        .foregroundColor(.fitnessPrimary)
                    Text(StringConstants.completedRoutines)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                }
                
                Spacer()
                
            }
            
            VStack(spacing: 12) {
                ForEach(plans, id: \.id) {  plan in
                    workoutPlanRow(planElement : plan.elements)
                }
            }
        }
    }
    
    private func workoutPlanRow(planElement: PlanElement) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: plan.imageURL)) { image in
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
                    Text(plan.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                    
                    Spacer()
                    
                    Text(plan.level)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(levelColor(for: plan.level))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(levelColor(for: plan.level).opacity(0.2))
                        .cornerRadius(8)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "repeat")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        Text(plan.reps)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        Text(plan.duration)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                }
                
                // Progress Bar
                HStack(spacing: 8) {
                    ProgressView(value: plan.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: progressColor(for: plan.progress)))
                        .scaleEffect(x: 1, y: 2)
                    
                    Text("\(Int(plan.progress * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
            }
        }
        .padding(16)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
        )
    }
    
}
