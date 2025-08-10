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
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {

                        activityCardsView
                        
                        caloriesChartView
                        
                        todayPlanView
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle("Your Activity")
        .navigationBarHidden(true)
        .showLoadingView(when: isLoading)
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=faces")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Welcome Back!")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    Text("Zayn Pradipta")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
    }
    
    private var activityCardsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Activity")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Menu {
                    Button("Today") { selectedTimeframe = "Today" }
                    Button("Weekly") { selectedTimeframe = "Weekly" }
                    Button("Monthly") { selectedTimeframe = "Monthly" }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimeframe)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            HStack(spacing: 12) {
                // Steps Card
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Steps")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("8,3")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("k")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("steps")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.bottom, 2)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(16)
                
                // Time Card
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Time")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("2 h 25")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("minutes")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.bottom, 2)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(16)
            }
        }
    }
    
    private var caloriesChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "flame")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text("Calories Burned")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
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
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
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
                                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                                    .frame(height: 120)
                                
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(data.day == "Thu" ? Color.white : Color.blue)
                                        .frame(height: CGFloat(data.calories) / 10)
                                }
                            }
                            .frame(width: 32)
                            
                            Text(data.day)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(data.day == "Thu" ? .white : .gray)
                        }
                    }
                }
                
                // Highlight current day calories
                if let todayData = activityData.caloriesData.first(where: { $0.day == "Thu" }) {
                    HStack {
                        Spacer()
                        Text("\(todayData.calories) Kcal")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(12)
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(16)
        }
    }
    
    private var todayPlanView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today Plan")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
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
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(plan.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(plan.level)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .cornerRadius(8)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(plan.reps)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(plan.duration)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                // Progress Bar
                ProgressView(value: plan.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 2)
            }
            
            Button(action: {
                showWorkoutTimer = true
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(16)
    }
}

#Preview {
    
    @Previewable @State  var showWorkoutTimer = false
    
    MetricsView(showWorkoutTimer: $showWorkoutTimer)
}
