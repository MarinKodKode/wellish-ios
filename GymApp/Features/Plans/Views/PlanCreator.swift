import SwiftUI

// MARK: - Create Plan View
struct CreatePlanView: View {
    @StateObject private var viewModel = PlanViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showGoalPicker = false
    @State private var showActivityPicker = false
    @State private var selectedDay: Int?
    @State private var showActivityTypeSheet = false
    
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
                        // Subtitle
                        HStack {
                            Text("¡Construye el plan perfecto para ti!")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button {
                                // Show help
                            } label: {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Detalles del plan
                        planDetailsSection
                        
                        // Objetivo
                        goalSection
                        
                        // Configuración
                        configurationSection
                        
                        // Actividades del plan
                        activitiesSection
                        
                        // Tags y categorías
                        tagsSection
                        
                        // Spacer para botones flotantes
                        Color.clear.frame(height: 180)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Crear plan")
            .navigationBarTitleDisplayMode(.large)
            .overlay(alignment: .bottom) {
                bottomActions
            }
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
    
    // MARK: - Plan Details Section
    private var planDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack(spacing: 12) {
                Image(systemName: "dumbbell.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Detalles del plan")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            // Card
            VStack(spacing: 12) {
                TextField("Nuevo plan", text: $viewModel.plan.name)
                    .textFieldStyle(CustomTextFieldStyle())
                
                TextField("Añade una descripción (opcional)", text: Binding(
                    get: { viewModel.plan.description ?? "" },
                    set: { viewModel.plan.description = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                    .textFieldStyle(CustomTextFieldStyle())
                    .lineLimit(3...5)
            }
            .padding()
            .background(Color(hex: "1E293B"))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Goal Section
    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Objetivo")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            Button {
                showGoalPicker = true
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: viewModel.plan.goal.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color(viewModel.plan.goal.color))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.plan.goal.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(viewModel.plan.goal.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "1E293B").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Configuration Section
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "clock.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                
                Text("Configuración")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                // Duration
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duración (semanas)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button {
                            if viewModel.plan.durationWeeks > 1 {
                                viewModel.plan.durationWeeks -= 1
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        
                        Text("\(viewModel.plan.durationWeeks)")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            viewModel.plan.durationWeeks += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Activities per week
                VStack(alignment: .leading, spacing: 8) {
                    Text("Actividades por semana")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button {
                            if viewModel.plan.activitiesPerWeek > 1 {
                                viewModel.plan.activitiesPerWeek -= 1
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        
                        Text("\(viewModel.plan.activitiesPerWeek)")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            viewModel.plan.activitiesPerWeek += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1E293B").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
        }
    }
    
    // MARK: - Activities Section
    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Text("Actividades del plan")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            if viewModel.plan.elements.isEmpty {
                emptyActivitiesState
            } else {
                activitiesList
            }
            
            // Calendar Grid
            calendarGrid
            
            // Add Activity Button
            Button {
                // Show instruction to select a day
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Añade una actividad")
                            .font(.headline)
                        Text("Selecciona un día del calendario")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyActivitiesState: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.5))
                .padding()
                .background(
                    Circle()
                        .fill(Color(hex: "1E293B").opacity(0.5))
                )
            
            VStack(spacing: 8) {
                Text("Aún no has agregado actividades")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Agrega actividades para cada día de tu plan")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1E293B").opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal)
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
    
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
            ForEach(1...viewModel.plan.totalDays, id: \.self) { day in
                let hasActivity = viewModel.plan.elements.contains { $0.day == day }
                
                Button {
                    selectedDay = day
                    showActivityTypeSheet = true
                } label: {
                    VStack(spacing: 4) {
                        Text("D")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Text("\(day)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(hasActivity ? Color.blue : Color(hex: "1E293B").opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(hasActivity ? 0 : 0.1), lineWidth: 1)
                            )
                    )
                    .foregroundColor(hasActivity ? .white : .secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "tag.fill")
                    .font(.title2)
                    .foregroundColor(.pink)
                
                Text("Tags y categorías")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    TextField("Agregar nuevo tag", text: .constant(""))
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    Button {
                        // Add tag
                    } label: {
                        Text("Agregar")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "475569"))
                            .cornerRadius(12)
                    }
                }
                
                TextField("Categorías (ej. cardio, fuerza)", text: .constant(""))
                    .textFieldStyle(CustomTextFieldStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1E293B").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
        }
    }
    
    // MARK: - Bottom Actions
    private var bottomActions: some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    await viewModel.savePlan()
                    dismiss()
                }
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.title3)
                    Text("Guardar plan")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.green, Color.green.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.green.opacity(0.3), radius: 10, y: 5)
            }
            
            Button {
                // Share plan
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    Text("Compartir plan")
                        .font(.headline)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "1E293B").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .padding()
        .background(
            Color(hex: "0F172A").opacity(0.95)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea()
        )
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
