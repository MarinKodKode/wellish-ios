import SwiftUI

public struct RoutineCreatorView: View {
   
    @ObservedObject var vm: RoutineViewModel

    @State var showingExercisePicker = false
    @State var selectedSetIndex: Int? = nil
    @State var newTagText: String = ""
    @State var showRoutineCreator: Bool = false

    public init(viewModel: RoutineViewModel) {
        _vm = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            Color.fitnessBackgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    headerSection
                    
                    routineInfoSection
                    
                    exercisesAndSetsSection
                    
                    tagsSection
                    
                    metricsSection
                    
                    saveButton
                    
                    shareButton
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
        .sheet(isPresented: $showingExercisePicker) {
            ExercisePickerView { exercise in
                showingExercisePicker = false
                vm.addSet(with: exercise)
            }
        }
        .sheet(isPresented: $showRoutineCreator) {
            RoutineCreatorSheet(isPresented: $showRoutineCreator)
        }
        .alert(item: $vm.error) { err in
            Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle(StringConstants.createRoutine, displayMode: .large)
        .navigationBarBackButtonHidden(true)
        .enableNativeSwipeBack()
        .hideKeyboardOnTap()
    }
}
