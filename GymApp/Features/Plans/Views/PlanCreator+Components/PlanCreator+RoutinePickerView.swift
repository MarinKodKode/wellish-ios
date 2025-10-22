
import SwiftUI

struct RoutinePickerView: View {

    @ObservedObject var viewModel: PlanCreatorViewModel
    let day: Int
    @Binding var dismissSheet: Bool
    let routineService = RoutineService()
    @State var routiness : [Routine] = []
    
    var body: some View {
        List {
            
            ForEach(routiness) { routine in
                Button {
                    handleRoutineSelection(routine)
                } label: {
                    RoutineRow(routine: routine)
                }
            }
        }
        .navigationTitle("Elige una rutina")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            Task {
                routiness = try await routineService.fetchRoutines()
            }
        }
    }
    
    private func handleRoutineSelection(_ routine: Routine) {
        // viewModel.addRoutine(routine, toDay: day)
        dismissSheet = false
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var dismissSheet = false
        
        var body: some View {
            RoutinePickerView(
                viewModel: PlanCreatorViewModel(),
                day: 23,
                dismissSheet: $dismissSheet
            )
        }
    }
    return PreviewWrapper()
}
