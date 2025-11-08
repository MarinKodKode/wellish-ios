//
//  ChallengeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/11/25.
//

import SwiftUI

// MARK: - Challenges Section (Para HomeView)

struct ChallengesSection: View {
    
    @StateObject private var viewModel = ChallengesViewModel()
    @State private var selectedChallenge: BaseChallenge?
    @State private var showLogSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Retos de la semana")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if viewModel.completedToday > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text("\(viewModel.completedToday)/\(viewModel.challenges.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            // Challenges Carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.challenges) { challenge in
                        ChallengeCard(challenge: challenge)
                            .onTapGesture {
                                selectedChallenge = challenge
                                showLogSheet = true
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showLogSheet) {
            if let challenge = selectedChallenge {
                ChallengeLogSheet(
                    challenge: challenge,
                    viewModel: viewModel
                )
            }
        }
        .overlay(
            // Success Animation
            Group {
                if viewModel.showSuccessAnimation {
                    SuccessAnimationView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
}

// MARK: - Challenge Card

struct ChallengeCard: View {
    let challenge: BaseChallenge
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient
            LinearGradient(
                colors: [
                    challenge.color,
                    challenge.color.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Icon & Title
                HStack(spacing: 8) {
                    Image(systemName: challenge.icon)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(challenge.period.displayName)
                            .font(.caption)
                            .opacity(0.9)
                        
                        Text(challenge.subtitle)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
                // Value
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(challenge.currentValue)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text(challenge.unit)
                        .font(.title3)
                        .opacity(0.9)
                }
                
                // Progress Bar
                VStack(spacing: 6) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 8)
                            
                            // Progress
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(
                                    width: geometry.size.width * challenge.progress,
                                    height: 8
                                )
                                .animation(.spring(), value: challenge.progress)
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text("\(challenge.currentValue) / \(challenge.goalValue) \(challenge.unit.lowercased())")
                            .font(.caption)
                        
                        Spacer()
                        
                        if challenge.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding(20)
        }
        .frame(width: 280, height: 200)
        .cornerRadius(20)
        .shadow(color: challenge.color.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Challenge Log Sheet

struct ChallengeLogSheet: View {
    
    let challenge: BaseChallenge
    @ObservedObject var viewModel: ChallengesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var inputValue: Int
    @State private var showHistory = false
    
    init(challenge: BaseChallenge, viewModel: ChallengesViewModel) {
        self.challenge = challenge
        self.viewModel = viewModel
        _inputValue = State(initialValue: challenge.currentValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header Card
                    headerCard
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Manual Input
                    manualInputSection
                    
                    // History Preview
                    historyPreviewSection
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(challenge.subtitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                ChallengeHistoryView(
                    challenge: challenge,
                    viewModel: viewModel
                )
            }
        }
    }
    
    // MARK: - Header Card
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(challenge.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: challenge.icon)
                    .font(.system(size: 36))
                    .foregroundColor(challenge.color)
            }
            
            // Progress
            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(inputValue)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text("/ \(challenge.goalValue)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(challenge.unit)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(challenge.color)
                            .frame(
                                width: geometry.size.width * min(Double(inputValue) / Double(challenge.goalValue), 1.0),
                                height: 12
                            )
                            .animation(.spring(), value: inputValue)
                    }
                }
                .frame(height: 12)
                
                Text("\(Int((Double(inputValue) / Double(challenge.goalValue)) * 100))% completado")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Completion Badge
            if inputValue >= challenge.goalValue {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text("¡Reto completado!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Acciones Rápidas")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "minus.circle.fill",
                    title: "-1",
                    color: .red
                ) {
                    if inputValue > 0 {
                        inputValue -= 1
                        viewModel.decrementChallenge(challenge, by: 1)
                    }
                }
                
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "+1",
                    color: challenge.color
                ) {
                    inputValue += 1
                    viewModel.incrementChallenge(challenge, by: 1)
                }
                
                QuickActionButton(
                    icon: "goforward.plus",
                    title: "+5",
                    color: challenge.color
                ) {
                    inputValue += 5
                    viewModel.incrementChallenge(challenge, by: 5)
                }
                
                QuickActionButton(
                    icon: "arrow.counterclockwise",
                    title: "Reset",
                    color: .orange
                ) {
                    inputValue = 0
                    viewModel.resetChallenge(challenge)
                }
            }
        }
    }
    
    // MARK: - Manual Input
    
    private var manualInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingresar Valor Manual")
                .font(.headline)
            
            VStack(spacing: 16) {
                // Stepper
                Stepper(value: $inputValue, in: 0...(challenge.goalValue * 2)) {
                    HStack {
                        Text("Valor actual:")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(inputValue) \(challenge.unit)")
                            .font(.headline)
                    }
                }
                
                // Save Button
                Button {
                    viewModel.setChallenge(challenge, value: inputValue)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Guardar Progreso")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(challenge.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
    
    // MARK: - History Preview
    
    private var historyPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Últimos 7 días")
                    .font(.headline)
                
                Spacer()
                
                Button("Ver todo") {
                    showHistory = true
                }
                .font(.caption)
                .foregroundColor(challenge.color)
            }
            
            let history = viewModel.getHistory(for: challenge, last: 7)
            
            if history.isEmpty {
                Text("Sin historial aún")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(history) { entry in
                            MiniHistoryCard(entry: entry, color: challenge.color)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Mini History Card

struct MiniHistoryCard: View {
    let entry: ChallengeHistoryEntry
    let color: Color
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(color, lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(entry.progress * 100))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            
            if entry.completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Challenge History View

struct ChallengeHistoryView: View {
    let challenge: BaseChallenge
    @ObservedObject var viewModel: ChallengesViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                let history = viewModel.getHistory(for: challenge, last: 30)
                
                if history.isEmpty {
                    Text("Sin historial disponible")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(history) { entry in
                        HistoryRow(entry: entry, challenge: challenge)
                    }
                }
            }
            .navigationTitle("Historial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - History Row

struct HistoryRow: View {
    let entry: ChallengeHistoryEntry
    let challenge: BaseChallenge
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateString)
                    .font(.headline)
                
                Text("\(entry.value) / \(entry.goalValue) \(challenge.unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(entry.progress * 100))%")
                    .font(.headline)
                    .foregroundColor(challenge.color)
                
                if entry.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Success Animation

struct SuccessAnimationView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("¡Reto Completado!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}

// MARK: - Preview

#Preview {
    ChallengesSection()
}
