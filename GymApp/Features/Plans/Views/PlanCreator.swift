import SwiftUI

// MARK: - Create Plan View
struct CreatePlanView: View {
    
    @StateObject var viewModel = PlanViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showGoalPicker = false
    @State var showActivityPicker = false
    @State var selectedDay: Int?
    @State var showActivityTypeSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "0F172A"), Color(hex: "1E293B"), Color(hex: "0F172A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        PlanCreator_Header
                        
                        PlanCreator_DetailsSection
                        
                        PlanCreator_GoalSection
                        
                        PlanCreator_ConfigurationSection
                        
                        PlanCreator_ActivitiesSection
                        
                        PlanCreator_TagsSection
                        
                        PlanCreatorButtonsSection
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Crear plan")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showGoalPicker) {
                GoalPickerSheet(selectedGoal: $viewModel.plan.goal)
            }
            .sheet(isPresented: $showActivityTypeSheet) {
                if let day = selectedDay {
                    ActivityTypePickerSheet(day: day, viewModel: viewModel)
                }
            }
        }
    }
    
    
    
    
    
    

    private var activitiesList: some View {
        VStack(spacing: 12) {
            ForEach(Array(viewModel.plan.elements.enumerated()), id: \.element.id) { index, element in
                HStack(spacing: 12) {
                    Image(systemName: element.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Día \(element.day)")
                            .font(.headline)
                        Text(element.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.plan.removeElement(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1E293B").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.horizontal)
    }
    
    
    
    
   
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "0F172A").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .foregroundColor(.primary)
    }
}

// MARK: - Goal Picker Sheet
struct GoalPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedGoal: PlanGoal
    
    var body: some View {
        NavigationView {
            List {
                ForEach(PlanGoal.allCases, id: \.self) { goal in
                    Button {
                        selectedGoal = goal
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: goal.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(goal.color))
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(goal.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(goal.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if goal == selectedGoal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Selecciona tu objetivo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Activity Type Picker Sheet
struct ActivityTypePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let day: Int
    @ObservedObject var viewModel: PlanViewModel
    @State private var showRoutinePicker = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        showRoutinePicker = true
                    } label: {
                        ActivityTypeRow(
                            icon: "dumbbell.fill",
                            title: "Rutina de Gym",
                            subtitle: "Elige de tus rutinas",
                            color: .blue
                        )
                    }
                    
                    ActivityTypeRow(
                        icon: "figure.run",
                        title: "Correr",
                        subtitle: "Agrega distancia y tiempo",
                        color: .green
                    )
                    
                    ActivityTypeRow(
                        icon: "bicycle",
                        title: "Ciclismo",
                        subtitle: "Configura tu ruta",
                        color: .orange
                    )
                    
                    ActivityTypeRow(
                        icon: "figure.pool.swim",
                        title: "Natación",
                        subtitle: "Define tu sesión",
                        color: .cyan
                    )
                    
                    ActivityTypeRow(
                        icon: "figure.mind.and.body",
                        title: "Yoga",
                        subtitle: "Elige tu práctica",
                        color: .purple
                    )
                    
                    ActivityTypeRow(
                        icon: "bed.double.fill",
                        title: "Día de descanso",
                        subtitle: "Recuperación activa",
                        color: .gray
                    )
                }
            }
            .navigationTitle("Día \(day)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ActivityTypeRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Placeholder ViewModel
class PlanViewModel: ObservableObject {
    @Published var plan: Plan
    
    init() {
        self.plan = Plan(name: "", goal: .general, durationWeeks: 4, activitiesPerWeek: 3)
    }
    
    func savePlan() async {
        // Implementation will come from services
    }
}

// MARK: - Preview
#Preview {
    CreatePlanView()
        .preferredColorScheme(.dark)
}

#Preview("With Activities") {
    let viewModel = PlanViewModel()
    
    // Add sample activities
    let gymActivity = Exercise(
        name: "Push Day",
        category: "Gym",
        equipment: "Barra",
        muscles: ["Pecho", "Tríceps"]
    )
    
    let runActivity = Exercise(
        name: "Correr 5K",
        category: "Cardio",
        muscles: ["Piernas"]
    )
    
    viewModel.plan.name = "Plan PPL 8 Semanas"
    viewModel.plan.description = "Plan de hipertrofia con enfoque en volumen"
    viewModel.plan.goal = .hypertrophy
    viewModel.plan.durationWeeks = 8
    viewModel.plan.activitiesPerWeek = 6
    viewModel.plan.addElement(PlanElement(activity: gymActivity, day: 1))
    viewModel.plan.addElement(PlanElement(activity: runActivity, day: 2))
    viewModel.plan.addElement(PlanElement(activity: gymActivity, day: 3))
    
    return CreatePlanView()
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
}

#Preview("Goal Picker Sheet") {
    GoalPickerSheet(selectedGoal: .constant(.hypertrophy))
        .preferredColorScheme(.dark)
}

#Preview("Activity Type Sheet") {
    ActivityTypePickerSheet(day: 5, viewModel: PlanViewModel())
        .preferredColorScheme(.dark)
}
