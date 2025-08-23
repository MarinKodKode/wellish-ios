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
    
    let activityData = ActivityData(
        steps: 8300,
        time: (hours: 2, minutes: 25),
        caloriesData: [
            CalorieData(day: "Mon", calories: 720),
            CalorieData(day: "Tue", calories: 780),
            CalorieData(day: "Wed", calories: 650),
            CalorieData(day: "Thu", calories: 874),
            CalorieData(day: "Fri", calories: 520),
            CalorieData(day: "Sat", calories: 680),
            CalorieData(day: "Sun", calories: 710)
        ]
    )
    
    let todayPlans = [
        WorkoutPlan(
            name: "Dumbbell Curl",
            level: "Beginner",
            reps: "12 × 4 Reps",
            duration: "12 Minutes",
            imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop",
            progress: 0.6
        ),
        WorkoutPlan(
            name: "Bench Press",
            level: "Intermediate",
            reps: "10 × 3 Reps",
            duration: "15 Minutes",
            imageURL: "https://images.unsplash.com/photo-1549476464-37392f717541?w=300&h=200&fit=crop",
            progress: 0.3
        )
    ]
    
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
    
    private var activityCardsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity Overview")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Menu {
                    Button("Today") { selectedTimeframe = "Today" }
                    Button("Weekly") { selectedTimeframe = "Weekly" }
                    Button("Monthly") { selectedTimeframe = "Monthly" }
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
                // Steps Card
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 20))
                            .foregroundColor(.fitnessPrimary)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Steps")
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
                            Text("steps")
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
                
                // Time Card
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
                            Text("Time")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.fitnessTextPrimary)
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("2 h 25")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                            Text("minutes")
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
    
    private var caloriesChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.fitnessWarning)
                    Text("Calories Burned")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                }
                
                Spacer()
                
                Menu {
                    Button("Daily") { selectedCalorieTimeframe = "Daily" }
                    Button("Weekly") { selectedCalorieTimeframe = "Weekly" }
                    Button("Monthly") { selectedCalorieTimeframe = "Monthly" }
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
                    Text("Today Plan")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessPrimary)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(todayPlans, id: \.id) { plan in
                    workoutPlanRow(plan: plan)
                }
            }
        }
    }
    
    private func workoutPlanRow(plan: WorkoutPlan) -> some View {
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
            
            Button(action: {
                navigatorRouter.push(.workoutTimer)
                showWorkoutTimer = true
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        LinearGradient(
                            colors: [.fitnessPrimary, .fitnessPrimary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .fitnessPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
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
    
    // MARK: - Helper Functions
    private func levelColor(for level: String) -> Color {
        switch level.lowercased() {
        case "beginner":
            return .fitnessSuccess
        case "intermediate":
            return .fitnessWarning
        case "advanced":
            return .fitnessError
        default:
            return .fitnessInfo
        }
    }
    
    private func progressColor(for progress: Double) -> Color {
        switch progress {
        case 0.0..<0.3:
            return .fitnessError
        case 0.3..<0.7:
            return .fitnessWarning
        default:
            return .fitnessSuccess
        }
    }
}

#Preview {
    @Previewable @State var showWorkoutTimer = false
    
    MetricsView(showWorkoutTimer: $showWorkoutTimer)
}
