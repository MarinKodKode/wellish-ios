
import SwiftUI

struct ProfileView: View {
    
    @Binding var showWorkoutTimer: Bool
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        ProfileView_Header_Section()
                            .padding(.horizontal, 20)
                        
                        Profile_Achievements()
                            .padding(.top, 24)
                        
                        SummarySectionView()
                        
                        quickActionsSection
                            .padding(.horizontal, 20)
                        
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarTitle("Perfil")
            .toolbarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    
                    Menu("", systemImage: "ellipsis"){
                        Button("Editar", systemImage: "pencil"){
                            
                        }
                        Button("Compartir", systemImage: "square.and.arrow.up"){
                            
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Stats Cards
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Stats")
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Text("Last 30 days")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }
            
            HStack(spacing: 12) {
                StatCard(
                    icon: "checkmark.circle.fill",
                    label: "Routines",
                    value: "\(vm.routinesCompleted)",
                    iconColor: .fitnessSuccess
                )
                
                StatCard(
                    icon: "flame.fill",
                    label: "Streak",
                    value: "\(vm.currentStreak)d",
                    iconColor: .energyFitnessOrange
                )
                
                StatCard(
                    icon: "clock.fill",
                    label: "Workout Time",
                    value: "\(vm.totalWorkoutTimeHours)h",
                    iconColor: .primaryFitnessBlue
                )
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)
            
            VStack(spacing: 12) {
                ActionRow(icon: "person.circle", label: "Body Metrics", action: {})
//                ActionRow(icon: "gear", label: "Settings", action: {})
//                ActionRow(icon: "bell", label: "Notifications", action: {})
                ActionRow(
                    icon : "rectangle.portrait.and.arrow.forward",
                    label : "Cerrar sesión",
                    action: {
                        vm.onTap_CloseSession()
                    })
            }
        }
    }
    
    // MARK: - Achievements
    
}

// MARK: - Subviews

/// Reusable stat card (like in MetricsView)
private struct StatCard: View {
    let icon: String
    let label: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
                
                Text(value)
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
}

/// Action row with icon and label
private struct ActionRow: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryFitnessBlue)
                
                Text(label)
                    .font(.body)
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.fitnessTextSecondary)
            }
            .padding(12)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(12)
        }
    }
}

/// Preview row for a saved routine
private struct RoutinePreviewRow: View {
    let routine: GymActivity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(.primaryFitnessBlue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.fitnessTextPrimary)
                HStack {
                    Text("\(routine.sets.count) exercises")
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                    Text(routine.formattedDuration)
                        .font(.caption)
                        .foregroundColor(.fitnessTextSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.fitnessTextSecondary)
        }
        .padding(12)
        .background(Color.fitnessBackgroundSecondary.opacity(0.7))
        .cornerRadius(12)
    }
}

/// Achievement badge



//MARK: - Previews

struct ProfileView_Prefixes_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var showWorkoutTimer: Bool = false
        
        ProfileView(showWorkoutTimer: $showWorkoutTimer)
            .preferredColorScheme(.dark)
        
        ProfileView(showWorkoutTimer: $showWorkoutTimer)
            .preferredColorScheme(.light)
    }
}
