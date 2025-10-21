//
//  ActivityTypePickerSheet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import SwiftUI

/// Sheet que permite seleccionar el tipo de actividad para un día específico dentro del plan.
/// Utiliza NavigationStack para navegación fluida hacia selectores específicos.
struct ActivityTypePickerSheet: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    let day: Int
    @ObservedObject var viewModel: PlanCreatorViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                mainActivitiesSection
                otherActivitiesSection
            }
            .navigationTitle("Día \(day)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
        }
    }
    
    // MARK: - View Components
    private var mainActivitiesSection: some View {
        Section {
            // Rutina de Gym - Navega a selector de rutinas
            NavigationLink {
                RoutinePickerView(
                    viewModel: viewModel,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRows(
                    icon: "dumbbell.fill",
                    title: "Rutina de Gym",
                    subtitle: "Elige de tus rutinas",
                    color: .blue
                )
            }
            
            // Correr
            Button {
                handleActivitySelection(.running)
            } label: {
                ActivityTypeRows(
                    icon: "figure.run",
                    title: "Correr",
                    subtitle: "Agrega distancia y tiempo",
                    color: .green
                )
            }
            
            // Día de descanso
            Button {
                handleActivitySelection(.rest)
            } label: {
                ActivityTypeRows(
                    icon: "bed.double.fill",
                    title: "Día de descanso",
                    subtitle: "Recuperación activa",
                    color: .gray
                )
            }
        }
    }
    
    private var otherActivitiesSection: some View {
        Section("Otras actividades") {
            // Ciclismo
            Button {
                handleActivitySelection(.cycling)
            } label: {
                ActivityTypeRows(
                    icon: "bicycle",
                    title: "Ciclismo",
                    subtitle: "Configura tu ruta",
                    color: .orange
                )
            }
            
            // Natación
            Button {
                handleActivitySelection(.swimming)
            } label: {
                ActivityTypeRows(
                    icon: "figure.pool.swim",
                    title: "Natación",
                    subtitle: "Define tu sesión",
                    color: .cyan
                )
            }
            
            // Yoga
            Button {
                handleActivitySelection(.yoga)
            } label: {
                ActivityTypeRows(
                    icon: "figure.mind.and.body",
                    title: "Yoga",
                    subtitle: "Elige tu práctica",
                    color: .purple
                )
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancelar") {
            isPresented = false
        }
    }
    
    // MARK: - Actions
    private func handleActivitySelection(_ activity: ActivityType) {
        // viewModel.addActivity(activity, forDay: day)
        isPresented = false
    }
}

// MARK: - Activity Type Rows Component
/// Componente reutilizable para mostrar cada opción de actividad
struct ActivityTypeRows: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono con círculo de color
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
            }
            
            // Textos
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Routine Picker View
/// Vista para seleccionar una rutina específica del gym
struct RoutinePickerView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: PlanCreatorViewModel
    let day: Int
    @Binding var dismissSheet: Bool
    
    // DEV: Raw data para pruebas
    private let library: [Exercise] = [
        Exercise(
            name: "Bench Press",
            category: "Chest",
            equipment: "Barbell",
            muscles: ["Chest", "Triceps"]
        ),
        Exercise(
            name: "Squat",
            category: "Legs",
            equipment: "Barbell",
            muscles: ["Quadriceps", "Glutes"]
        ),
        Exercise(
            name: "Deadlift",
            category: "Back",
            equipment: "Barbell",
            muscles: ["Back", "Hamstrings"]
        ),
        Exercise(
            name: "Overhead Press",
            category: "Shoulders",
            equipment: "Barbell",
            muscles: ["Deltoids"]
        ),
        Exercise(
            name: "Pull-ups",
            category: "Back",
            equipment: "Bodyweight",
            muscles: ["Lats", "Biceps"]
        ),
        Exercise(
            name: "Lunges",
            category: "Legs",
            equipment: "Dumbbell",
            muscles: ["Quadriceps", "Glutes", "Hamstrings"]
        )
    ]
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(library) { routine in
                Button {
                    handleRoutineSelection(routine)
                } label: {
                    RoutineRow(routine: routine)
                }
            }
        }
        .navigationTitle("Elige una rutina")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Actions
    private func handleRoutineSelection(_ routine: Exercise) {
        // viewModel.addRoutine(routine, toDay: day)
        
        // Cierra todo el sheet inmediatamente
        dismissSheet = false
    }
}

// MARK: - Routine Row Component
/// Componente para mostrar cada rutina en la lista
struct RoutineRow: View {
    let routine: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(routine.category ?? "Sin categoría")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let equipment = routine.equipment {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.caption2)
                        Text(equipment)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary.opacity(0.8))
                }
            }
            
            Spacer()
            
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Supporting Types (temporal para desarrollo)
enum ActivityType {
    case running
    case rest
    case cycling
    case swimming
    case yoga
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var showSheet = true
        
        var body: some View {
            Button("Show Sheet") {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                ActivityTypePickerSheet(
                    isPresented: $showSheet,
                    day: 1,
                    viewModel: PlanCreatorViewModel()
                )
            }
        }
    }
    
    return PreviewWrapper()
}
