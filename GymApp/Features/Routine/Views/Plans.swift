//
//  RoutinePlans.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import SwiftUI

struct PlansView: View {
    
    @StateObject var vm: RoutineViewModel
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
                                    navigationRouter.goTo(.createRoutine)
                                }){
                                    Text(StringConstants.plansAddNewPlan)
                                }
                            }
                            .padding(.horizontal)

                            if $vm.savedRoutines.isEmpty {
                                Text("No routines saved yet.")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(vm.savedRoutines) { routine in
                                    PlansRoutineRowView(routine: routine)
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

                            if $vm.savedRoutines.isEmpty {
                                Text("No routines saved yet.")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(vm.savedRoutines) { routine in
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
        }
    }
    
}
// MARK: - All Routines List

private struct AllRoutinesView: View {
    @ObservedObject var vm: RoutineViewModel

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

// MARK: - Previews

struct PlansView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.light)

            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
