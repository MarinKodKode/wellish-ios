import SwiftUI

struct ChallengesSection: View {
    
    @StateObject private var viewModel = ChallengesViewModel()
    @State private var selectedChallenge: BaseChallenge?
    @State private var showLogSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            Group {
                if viewModel.showSuccessAnimation {
                    SuccessAnimationView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
}


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
