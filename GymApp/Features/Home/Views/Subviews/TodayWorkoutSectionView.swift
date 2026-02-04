//
//  TodayWorkoutsView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//

import SwiftUI

struct TodayWorkoutView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    let vm = PlanTrackerCurrentDayViewModel()
    @State var activities : [TodayActivityModel] = []
    
    var body: some View {
        VStack() {
            SectionBarTitle("La rutina de hoy 🔥")
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center){
                    ForEach(activities){ activity in
                        ZStack {
                            
                            BackgroundCardImage(image: activity.image)
                            
                            Color.black.opacity(0.4)
                            VStack(spacing : 12) {
                                
                                TodayWorkoutTitleCard(title: activity.title)
                                
                                RoutineStatisticsRowView(
                                    calories: "\(activity.calories) KCAL",
                                    time: "\(activity.time) mins",
                                    exercises: "23 exercises"
                                )
                            }
                        }
                        .frame(
                            width : UIScreen.screenWidth * 0.95,
                            height: UIScreen.screenHeight * 0.25)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            navigationRouter
                                .goTo(
                                    .todayWorkout(plan: activity.parentPlan)
                                )
                        }
                    }
                }
            }
            .frame(height: UIScreen.screenHeight * 0.25)
        }
        .task {
            await self.activities = vm.buildTodayActivites()
            await vm.initView()
        }
    }
}

struct BackgroundCardImage : View {
    
    var image : String
    
    init(image: String) {
        self.image = image
    }
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if phase.error != nil {
                Image("background_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Image("background_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
        }
    }
}

struct TodayWorkoutTitleCard : View {
    
    let title : String?
    
    init(title: String?) {
        self.title = title
    }
    
    var body: some View {
        Text("\(title?.prefix(22) ?? "Today's challenge")..." )
            .font(.custom("Lemon", size: 40))
            .foregroundColor(.fitnessTextPrimary)
            .multilineTextAlignment(.center)
    }
}
