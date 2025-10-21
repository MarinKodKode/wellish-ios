import SwiftUI

struct CreatePlanView: View {
    
    @StateObject var vm = PlanCreatorViewModel()
   
    @Environment(\.dismiss) var dismiss
    
    @State var showGoalPicker = false
    @State var showActivityPicker = false
    @State var selectedDay: Int?
    @State var showActivityTypeSheet = false
    
    public var body: some View {
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
        .sheet(isPresented: $showGoalPicker) {
            GoalPickerSheet(selectedGoal: $vm.plan.goal)
        }
        .sheet(isPresented: $showActivityTypeSheet) {
            if let day = selectedDay {
                ActivityTypePickerSheet(isPresented: $showActivityTypeSheet, day: day, viewModel: vm)
            }
        }
        .sheet(isPresented: $vm.showRoutinePickerSheet) {
            ExercisePickerView { exercise in
                vm.showRoutinePickerSheet = false
            }
        }
        .navigationTitle("Crear plan")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .enableNativeSwipeBack()
        .hideKeyboardOnTap()
        .showLoadingView(when: vm.isLoading)
        
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

