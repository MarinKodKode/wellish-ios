//
//  WorkoutTimerView.swift
//  GymApp
//
//  Created by Manuel Alejandro Hernandez Marín on 23/07/25.
//

import SwiftUI

struct WorkoutTimerView: View {
    @Binding var showWorkoutTimer: Bool
    @State private var selectedTimeframe = "Weekly"
    @State private var currentTime: Double = 25.10
    @State private var isPlaying = false
    @State private var timer: Timer?
    
    let workoutSession = WorkoutSession(
        name: "Dumbbell Curl",
        currentTime: 25.10,
        totalTime: 45.0,
        calories: 251,
        duration: 25,
        reps: "12 × 4 Reps"
    )
    
    let activityHistory = [
        ActivityHistoryItem(
            name: "Dumbbell Curl",
            date: "Tue, June 11",
            time: "09:50 PM",
            calories: 452,
            duration: "1 h 13 min",
            sets: 10
        ),
        ActivityHistoryItem(
            name: "Dumbbell Curl",
            date: "Mon, June 10",
            time: "07:30 PM",
            calories: 678,
            duration: "1 h 42 min",
            sets: 14
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Timer Circle
                            timerCircleView
                            
                            // Stats Row
                            statsRowView
                            
                            // Activity History
                            activityHistoryView
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                showWorkoutTimer = false
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Dumbbell Curl")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var timerCircleView: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 8)
                .frame(width: 280, height: 280)
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: currentTime / 45.0)
                .stroke(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: currentTime)
            
            // Center Content
            VStack(spacing: 8) {
                Button(action: {
                    toggleTimer()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Text(String(format: "%.2f", currentTime))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Minutes")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // Progress Indicator
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .offset(y: -140)
                .rotationEffect(.degrees(Double(currentTime / 45.0) * 360 - 90))
                .animation(.easeInOut(duration: 0.3), value: currentTime)
        }
    }
    
    private var statsRowView: some View {
        HStack(spacing: 16) {
            // Calories
            HStack(spacing: 8) {
                Image(systemName: "flame")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Text("251 Kcal")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(20)
            
            // Duration
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Text("25 Min")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(20)
            
            // Reps
            HStack(spacing: 8) {
                Image(systemName: "dumbbell")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Text("12 × 4 Reps")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(20)
        }
    }
    
    private var activityHistoryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity History")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Menu {
                    Button("Daily") { selectedTimeframe = "Daily" }
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
            
            VStack(spacing: 12) {
                ForEach(activityHistory, id: \.id) { activity in
                    activityHistoryRow(activity: activity)
                }
            }
        }
    }
    
    private func activityHistoryRow(activity: ActivityHistoryItem) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(activity.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(activity.date)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    Text(activity.time)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            
            HStack(spacing: 24) {
                HStack(spacing: 4) {
                    Image(systemName: "flame")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("\(activity.calories) Kcal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(activity.duration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "dumbbell")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("\(activity.sets) sets")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(16)
    }
    
    private func toggleTimer() {
        isPlaying.toggle()
        
        if isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if currentTime > 0 {
                    currentTime -= 0.1
                } else {
                    timer?.invalidate()
                    isPlaying = false
                }
            }
        } else {
            timer?.invalidate()
        }
    }
}
