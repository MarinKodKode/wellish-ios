//
//  RoutinePlans.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import SwiftUI

struct PlansView: View {
    
    @StateObject var vm: GymActivityViewModel
    @StateObject var plansVM: PlansViewViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        
                        headerSection
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(StringConstants.plansSubtitle)
                                .font(.title2.bold())
                                .foregroundColor(.fitnessTextPrimary)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(templates.indices, id: \.self) { index in
                                        TemplateCard(template: templates[index]) {
                                            print("Applied: \(templates[index].name)")
                                        }
                                        .padding(.leading, index == 0 ? 20 : 8)
                                        .padding(.trailing,index == templates.count - 1 ? 20 : 8
                                        )
                                    }
                                }
                            }
                        }

                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(StringConstants.plansMyPlans)
                                    .font(.title2.bold())
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                Button(action: {
                                    navigationRouter.goTo(.createPlan)
                                }){
                                    Text(StringConstants.plansAddNewPlan)
                                }
                            }
                            .padding(.horizontal)

                            if $plansVM.plans.isEmpty {
                                Text("No plans saved yet.")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(plansVM.plans) { plan in
                                    PlansPlanElementRow(plan: plan)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(StringConstants.plansMyRoutines)
                                    .font(.title2.bold())
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                Button(action: {
                                    navigationRouter.goTo(.createRoutine)
                                }){
                                    Text(StringConstants.createRoutine)
                                }
                            }
                            .padding(.horizontal)

                            if $plansVM.routines.isEmpty {
                                Text("No routines saved yet.")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(plansVM.routines) { routine in
                                    PlansRoutineRowView(routine: routine)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitle("Planes")
            .onAppear{
                plansVM.initView()
            }
        }
    }
    
}

private struct AllRoutinesView: View {
    @ObservedObject var vm: GymActivityViewModel

    var body: some View {
        List {
            if vm.savedRoutines.isEmpty {
                Text("No routines yet.")
                    .foregroundColor(.fitnessTextSecondary)
            } else {
                ForEach(vm.savedRoutines) { routine in
                    PlansRoutineRowView(routine: routine)
                }
            }
        }
        .background(Color.fitnessBackgroundPrimary)
        .navigationTitle("All Routines")
    }
}
