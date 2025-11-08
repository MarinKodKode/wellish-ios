//
//  PopularPlansSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 07/11/25.
//

import SwiftUI

struct PopularPlansSection: View {
    
    @State var plans : [Plan] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringConstants.plansSubtitle)
                .font(.title2.bold())
                .foregroundColor(.fitnessTextPrimary)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(plans.enumerated()), id: \.element.self) { index, plan in
                        
                        TemplateCard(
                            plan: plan
                        ) {
                            print("Applied: \(plan.name)")
                        }
                        .padding(.leading, index == 0 ? 20 : 8)
                        .padding(.trailing, index == plans.count - 1 ? 20 : 8)
                    }
                }
            }
        }
        .task {
            plans = PlanDataset().getPlans()
        }
    }
}

#Preview {
    PopularPlansSection()
}
