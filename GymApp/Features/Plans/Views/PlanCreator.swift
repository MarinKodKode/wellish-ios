import SwiftUI

// MARK: - Create Plan View
struct CreatePlanView: View {
    
    @StateObject var viewModel = PlanCreatorViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showGoalPicker = false
    @State var showActivityPicker = false
    @State var selectedDay: Int?
    @State var showActivityTypeSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        PlanCreator_Header
                        
                        PlanCreator_DetailsSection
                        
                        PlanCreator_GoalSection
                        
                        PlanCreator_ConfigurationSection
                        
                        PlanCreator_ActivitiesSection
                        
                        PlanCreator_TagsSection
                        
                        PlanCreatorButtonsSection
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Crear plan")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showGoalPicker) {
                GoalPickerSheet(selectedGoal: $viewModel.plan.goal)
            }
            .sheet(isPresented: $showActivityTypeSheet) {
                if let day = selectedDay {
                    ActivityTypePickerSheet(day: day, viewModel: viewModel)
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    CreatePlanView()
        .preferredColorScheme(.dark)
}

#Preview("With Activities") {
    let viewModel = PlanCreatorViewModel()
    
    // Add sample activities
    let gymActivity = Exercise(
        name: "Push Day",
        category: "Gym",
        equipment: "Barra",
        muscles: ["Pecho", "Tríceps"]
    )
    
    let runActivity = Exercise(
        name: "Correr 5K",
        category: "Cardio",
        muscles: ["Piernas"]
    )
    
    viewModel.plan.name = "Plan PPL 8 Semanas"
    viewModel.plan.description = "Plan de hipertrofia con enfoque en volumen"
    viewModel.plan.goal = .hypertrophy
    viewModel.plan.durationWeeks = 8
    viewModel.plan.activitiesPerWeek = 6
    viewModel.plan.addElement(PlanElement(activity: gymActivity, day: 1))
    viewModel.plan.addElement(PlanElement(activity: runActivity, day: 2))
    viewModel.plan.addElement(PlanElement(activity: gymActivity, day: 3))
    
    return CreatePlanView()
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
}

#Preview("Goal Picker Sheet") {
    GoalPickerSheet(selectedGoal: .constant(.hypertrophy))
        .preferredColorScheme(.dark)
}

#Preview("Activity Type Sheet") {
    ActivityTypePickerSheet(day: 5, viewModel: PlanCreatorViewModel())
        .preferredColorScheme(.dark)
}
