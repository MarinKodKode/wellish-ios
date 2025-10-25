import SwiftUI

struct ActivityPickerView: View {
    
    @ObservedObject var vm: PlanCreatorViewModel
    
    let category: ActivityCategory
    
    /// Día del plan
    let day: Int
    
    @Binding var dismissSheet: Bool
    
    @State private var activities: [ActivityType] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if activities.isEmpty {
                emptyView
            } else {
                activitiesList
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadActivities()
        }
    }
    
    // MARK: - Navigation Title
    
    private var navigationTitle: String {
        switch category {
        case .gym: return "Elige una rutina"
        case .running: return "Elige una carrera"
        case .cycling: return "Elige una ruta"
        case .swimming: return "Elige una sesión"
        case .walking: return "Elige una caminata"
        case .yoga: return "Elige una práctica"
        case .pilates: return "Elige una clase"
        case .rest: return "Elige descanso"
        default: return "Elige una actividad"
        }
    }
        
    private var activitiesList: some View {
        List {
            ForEach(ActivityDataset.allActivitiesAsTypes) { activityType in
                Button {
//                    handleActivitySelection(activityType)
                } label: {
                    ActivityRowView(activityType: activityType)
                }
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Cargando actividades...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty View
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: category.defaultIcon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No hay actividades")
                .font(.headline)
            
            Text("Crea tu primera \(category.rawValue.lowercased()) para agregarla a un plan")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Crear nueva") {
                // Navegar a creación de actividad
                // vm.showActivityCreation(category: category)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Error al cargar")
                .font(.headline)
            
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Reintentar") {
                Task {
                    await loadActivities()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Actions
    
    private func handleActivitySelection(_ activityType: ActivityType) {
//        vm.addActivityToPlan(activityType, forDay: day)
        dismissSheet = false
    }
    
    private func loadActivities() async {
        isLoading = true
        errorMessage = nil
        isLoading = false
    }
}

// MARK: - Activity Row View

private struct ActivityRowView: View {
    let activityType: ActivityType
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono
            ZStack {
                Circle()
                    .fill(Color(hex: activityType.colorHex).opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: activityType.icon)
                    .foregroundColor(Color(hex: activityType.colorHex))
                    .font(.system(size: 20))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(activityType.displayName)
                    .font(.headline)
                
                // Subtítulo según tipo
                if let subtitle = activitySubtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
//            
//            // Badge si es template o premium
//            if activityType.isTemplate {
//                Text("Template")
//                    .font(.caption2)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.blue.opacity(0.2))
//                    .foregroundColor(.blue)
//                    .cornerRadius(4)
//            }
        }
        .padding(.vertical, 4)
    }
    
    private var activitySubtitle: String? {
        var parts: [String] = []
        
        if let duration = activityType.estimatedDuration {
            parts.append("\(duration) min")
        }
        
        if let calories = activityType.estimatedCalories {
            parts.append("\(calories) kcal")
        }
        
        // Info específica por tipo
        switch activityType {
        case .running(let running):
            if let distance = running.targetDistanceKm {
                parts.append("\(String(format: "%.1f", distance)) km")
            }
            
        case .cycling(let cycling):
            if let distance = cycling.targetDistanceKm {
                parts.append("\(String(format: "%.1f", distance)) km")
            }
            
        case .swimming(let swimming):
            if let laps = swimming.targetLaps {
                parts.append("\(laps) largos")
            }
            
        case .gym(let gym):
            parts.append("\(gym.sets.count) ejercicios")
            
        case .walking(let walking):
            if let distance = walking.targetDistanceKm {
                parts.append("\(String(format: "%.1f", distance)) km")
            }
            
        case .rest(let rest):
            parts.append(rest.restType.rawValue)
            
        default:
            break
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
}
