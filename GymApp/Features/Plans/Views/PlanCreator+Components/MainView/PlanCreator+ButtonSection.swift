import SwiftUI

extension CreatePlanView {

    var PlanCreatorButtonsSection : some View {
        Button(action: {
            self.vm.isLoading = true
            Task {
                await vm.savePlan()
//                if ok {
//                    // Success feedback can be added later
//                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.vm.isLoading = false
//                self.vm.savedSuccess = true
            }
        }) {
            HStack(spacing: 12) {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                    
                    Text(StringConstants.saveRoutine)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                LinearGradient(
                    colors: [.fitnessSuccess, .fitnessSuccess.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .buttonStyle(ScaleButtonStyle())
        }
    }
}
