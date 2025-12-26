import SwiftUI

public struct PlanDetailView: View {
    
    @State var plan: Plan
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationRouter: NavigationRouter
    @State var startedPlan : Bool = false
    @ObservedObject var vm: PlanDetailViewModel
    
    public var body : some View {
        ZStack{
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    headerSection
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                    
                    Group {
                        if plan.isBeingTracked {
                            progressSection
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            startPlanButton
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    activitiesSection
                        .padding(.horizontal, 16)
                    
                }
            }
        }
        .navigationTitle(plan.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Menu("", systemImage: "ellipsis"){
                    Button("Pausar", systemImage: "pause.circle"){
                    }
                    Button("Compartir", systemImage: "square.and.arrow.up"){
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let description = plan.description {
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.fitnessTextSecondary))
                    .multilineTextAlignment(.leading)
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.fitnessInfo)
                    Text(plan.formattedDuration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(8)
                
                HStack(spacing: 6) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                    Text("\(plan.totalActivities) activities")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.energyFitnessOrange)
                Text("Progress Overview")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text(plan.progressText)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.fitnessTextPrimary)
                    Spacer()
                    Text("\(Int(plan.completionPercentage))%")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.energyFitnessOrange)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.fitnessInfo)
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.energyFitnessOrange, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (plan.completionPercentage / 100), height: 12)
                    }
                }
                .frame(height: 12)
            }
            .padding(16)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(16)
            .clipped()
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 0)
        }
    }
    
    private var startPlanButton: some View {
            Button(action: {
                Task {
                    await vm.startTrackingPlan(plan)
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("Start Plan")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
            }
        }
    
    // MARK: - Activities Section
    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Text("Plan Activities")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                Spacer()
            }
            
            if plan.elements.isEmpty {
                emptyStateView
            } else {
                ForEach(Array(plan.elements.enumerated()), id: \.element.id) { index, element in
                    Button(action: {
                        navigationRouter
                            .goTo(.gymActivityDetail(routines[0]))
                    }, label: {
                        PlanElementRow(
                            element: element,
                            onToggleComplete: {
                                plan.markElementCompleted(at: index, completed: !element.completed)
                            }
                        )
                    })
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 64))
                .foregroundColor(Color(white: 0.3))
            
            Text("No activities yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(white: 0.5))
            
            Text("Add activities to start your plan")
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
}

// MARK: - Plan Element Row Component
struct PlanElementRow: View {
    let element: PlanElement
    let onToggleComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail or Icon
            if let imageURL = element.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    activityIcon
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                activityIcon
                    .frame(width: 80, height: 80)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title and Day Badge
                HStack(spacing: 8) {
                    Text(element.displayName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Day Badge
                    Text("Day \(element.day)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(6)
                }
                
                // Activity Type Badge
                Text(element.activityCategoryString.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: element.colorHex))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: element.colorHex).opacity(0.2))
                    .cornerRadius(6)
                
                // Details
                HStack(spacing: 12) {
                    // Duration
                    if let duration = element.expectedDuration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(Color(white: 0.6))
                            Text("\(duration) min")
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.6))
                        }
                    }
                    
                    // Calories
                    if let calories = element.expectedCalories {
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.system(size: 12))
                                .foregroundColor(Color(white: 0.6))
                            Text("\(calories) kcal")
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.6))
                        }
                    }
                }
                
                // Completion Status or Performance
                if element.completed {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        
                        if let performance = element.performanceSummary {
                            Text(performance)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                                .lineLimit(1)
                        } else {
                            Text("Completed")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        if let badge = element.performanceBadge {
                            Text(badge)
                                .font(.system(size: 10))
                        }
                    }
                } else {
                    // Scheduled Time
                    if let time = element.formattedTime {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.badge")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            Text(time)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            Button(action: onToggleComplete) {
                ZStack {
                    Circle()
                        .fill(element.completed ? Color.green.opacity(0.2) : Color.blue)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: element.completed ? "checkmark" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(element.completed ? .green : .white)
                }
            }
        }
        .padding(12)
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
        .clipped()
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 0)
    }
    
    private var activityIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [iconColor.opacity(0.3), iconColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image(systemName: element.icon)
                .font(.system(size: 32))
                .foregroundColor(iconColor)
        }
    }
    
    private var iconColor: Color {
        Color(hex: element.colorHex)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PlanDetailView(
plan: Plan(
            name: "4-Week Fitness Challenge",
            description: "Complete fitness plan to improve your overall health and strength",
            category: "Fitness",
            elements: [
                PlanElement(
                    activity: .running(RunningActivity(
                        name: "Morning Run",
                        runningType: .steady,
                        targetDistanceKm: 5.0,
                        targetDurationMinutes: 30,
                        estimatedCalories: 300
                    )),
                    day: 1,
                    scheduledTime: Calendar.current
                        .date(
                            bySettingHour: 7,
                            minute: 0,
                            second: 0,
                            of: Date()
                        ),
                    imageURL: ""
                ),
                PlanElement(
                    activity: .gym(GymActivity(
                        name: "Upper Body Strength",
                        sets: [],
                        estimatedDurationMinutes: 45,
                        estimatedCalories: 320
                    )),
                    day: 1,
                    completed: true,
                    completedAt: Date(),
                    actualDurationMinutes: 48,
                    actualCalories: 340,
                    rpe: 8,
                    imageURL: ""
                ),
                PlanElement(
                    activity: .rest(RestActivity(
                        name: "Active Recovery",
                        restType: .active
                    )),
                    day: 2,
                    imageURL: ""
                ),
                PlanElement(
                    activity: .cycling(CyclingActivity(
                        name: "Evening Ride",
                        targetDistanceKm: 15.0,
                        targetDurationMinutes: 40,
                        estimatedCalories: 280
                    )),
                    day: 2,
                    scheduledTime: Calendar.current
                        .date(
                            bySettingHour: 18,
                            minute: 0,
                            second: 0,
                            of: Date()
                        ),
                    imageURL: ""
                )
            ],
            goal: .general,
            durationWeeks: 4
), vm:  PlanDetailViewModel()
)
    }
}
