
import SwiftUI

struct ActivityTypePickerSheet: View {

    @Binding var isPresented: Bool
    let day: Int
    @ObservedObject var viewModel: PlanCreatorViewModel
    
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
    
    private var mainActivitiesSection: some View {
        Section {
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
    
    private func handleActivitySelection(_ activity: ActivityType) {
        // viewModel.addActivity(activity, forDay: day)
        isPresented = false
    }
}




