
import SwiftUI

extension RoutineCreatorView {
    
    var routineInfoSection: some View {
        widget.enhancedSectionView(
            title: StringConstants.routinedetailsTitle,
            icon: "dumbbell.fill",
            iconColor: .primaryFitnessBlue
        ) {
            VStack(spacing: 20) {
                widget.customTextField(
                    placeholder: StringConstants.routineName,
                    text: $vm.gymActivity.name,
                    icon: "pencil",
                    iconColor: .primaryFitnessBlue
                )
                
                widget.customTextField(
                    placeholder: StringConstants.routineDescription,
                    text: $vm.gymActivity.category.replacingNilWith(""),
                    icon: "text.alignleft",
                    iconColor: .fitnessTextSecondary
                )
            }
        }
    }
}
