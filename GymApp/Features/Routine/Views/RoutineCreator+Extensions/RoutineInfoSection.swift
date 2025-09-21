//
//  RoutineInfoSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView {
    
    var routineInfoSection: some View {
        enhancedSectionView(
            title: StringConstants.routinedetailsTitle,
            icon: "dumbbell.fill",
            iconColor: .primaryFitnessBlue
        ) {
            VStack(spacing: 20) {
                customTextField(
                    placeholder: StringConstants.routineName,
                    text: $vm.routine.name,
                    icon: "pencil",
                    iconColor: .primaryFitnessBlue
                )
                
                customTextField(
                    placeholder: StringConstants.routineDescription,
                    text: $vm.routine.category.replacingNilWith(""),
                    icon: "text.alignleft",
                    iconColor: .fitnessTextSecondary
                )
            }
        }
    }
}


// MARK: - Preview

#Preview {
    RoutineCreatorView(viewModel: RoutineViewModel())
        .preferredColorScheme(.light)
}

#Preview {
    RoutineCreatorView(viewModel: RoutineViewModel())
        .preferredColorScheme(.dark)
}
