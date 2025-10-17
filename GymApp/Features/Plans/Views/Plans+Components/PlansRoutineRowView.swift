//
//  PlansRoutineRowView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/09/25.
//

import SwiftUI

struct PlansRoutineRowView: View {
    let routine: Routine

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(.primaryFitnessBlue)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.fitnessTextPrimary)
                Text("\(routine.sets.count) exercises · \(routine.totalSeriesCount) series")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.fitnessTextSecondary)
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}
