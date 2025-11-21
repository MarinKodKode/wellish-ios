//
//  Metrics+CompletedActivitiesView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 31/10/25.
//

import SwiftUI

struct Metrics_CompletedActivitiesView : View {
    
    @EnvironmentObject  var navigatorRouter : NavigationRouter
    @ObservedObject var vm = MetricsHistoryViewModel()
    
    let title : String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Group {
            if !vm.completedActivitiesLoaded {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack(spacing: 8) {
                            Text(title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                        }
                        Spacer()
                    }
                    
                    ForEach(0..<3 , id : \.self){ _ in
                        CompletedActivityCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
            }else {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack(spacing: 8) {
                            Text(title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                        }
                        Spacer()
                    }
                    VStack(spacing: 16) {
                        ForEach(vm.completedActivities) {  _ in
                            CompletedActivityCard()
                                .onTapGesture {
                                    navigatorRouter.goTo(.summaryDay)
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .task {
            await vm.initView()
        }
    }
    
}

