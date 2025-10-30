import SwiftUI

struct CreatePlanView: View {
    
    @StateObject var vm = PlanCreatorViewModel()
   
    @Environment(\.dismiss) var dismiss
    
    @State var showGoalPicker = false
    @State var showSpinner = false
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
                    
                    SaveButtonWidget(text: "Guardar plan", action: {print("Plan")}, isLoading: $vm.isLoading)
                    
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $showGoalPicker) {
            GoalPickerSheet(selectedGoal: $vm.plan.goal)
        }
        .sheet(isPresented: $showActivityTypeSheet) {
            if let day = vm.selectedDay {
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
