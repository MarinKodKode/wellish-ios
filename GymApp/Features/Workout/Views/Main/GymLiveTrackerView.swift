import SwiftUI
import Lottie

struct GymLiveTrackerView: View {
    // Observar el singleton compartido
    @ObservedObject private var tracker = GymLiveTrackerViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    // Solo necesitamos el planElement para iniciar
    let planElement: PlanElement
    
    var body: some View {
        ZStack {
            
            Color.fitnessBackgroundPrimary.ignoresSafeArea()
            
            if tracker.showWorkoutComplete {
                WorkoutCompleteView(
                    totalTime: tracker.elapsedTime,
                    caloriesBurned: tracker.caloriesBurned,
                    onDismiss: {
                        dismiss()
                        tracker.reset()
                    }
                )
            } else if let gymActivity = tracker.currentGymActivity {
                ScrollView {
                    VStack(spacing: 16) {
                        HeaderView(
                            workoutName: gymActivity.name,
                            elapsedTime: tracker.elapsedTime
                        )
                        
                        ProgressCardView(
                            completedSets: tracker.completedSetsCount,
                            totalSets: tracker.totalSets,
                            progress: tracker.progress
                        )
                        
                        MetricsViewLocal(
                            elapsedTime: tracker.elapsedTime,
                            caloriesBurned: tracker.caloriesBurned,
                            currentExercise: tracker.currentExerciseIndex + 1,
                            totalExercises: gymActivity.sets.count
                        )
                        
                        if tracker.isResting {
                            RestTimerView(
                                restTimer: tracker.restTimer,
                                onSkip: {
                                    tracker.skipRest()
                                }
                            )
                        }
                        
                        if let currentSet = tracker.currentRoutineSet {
                            CurrentExerciseCard(
                                routineSet: currentSet,
                                currentSet: tracker.currentSet,
                                property: $tracker.currentSet,
                                currentExerciseIndex: tracker.currentExerciseIndex,
                                totalExercises: gymActivity.sets.count,
                                completedSets: tracker.completedSets[tracker.currentExerciseIndex] ?? [],
                                totalSetsInExercise: currentSet.series.count,
                                isTimerRunning: tracker.isTimerRunning,
                                isResting: tracker.isResting,
                                onStart: {
                                    tracker.startWorkout(with: planElement)
                                },
                                onPause: tracker.pauseWorkout,
                                onResume: tracker.resumeWorkout,
                                onCompleteSet: tracker.completeSet
                            )
                            
                        }
                        
                        ExerciseListView(
                            sets: gymActivity.sets,
                            currentIndex: tracker.currentExerciseIndex
                        )
                        
                        if tracker.isTimerRunning {
                            Button("Saltar ejercicio") {
                                tracker.skipExercise()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                            .foregroundColor(.gray)
                            .cornerRadius(16)
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            } 
            
            // Set Complete Animation
            if tracker.showSetComplete {
                SetCompleteAnimation()
            }
        }
        .navigationBarBackButtonHidden(tracker.isTimerRunning)
        .toolbar {
            if tracker.isTimerRunning {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showExitConfirmation()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Salir")
                        }
                    }
                }
            }
        }
    }
    
    private func showExitConfirmation() {
        tracker.pauseWorkout()
        dismiss()
    }
}

// MARK: - Start Workout View
struct StartWorkoutView: View {
    let planElement: PlanElement
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            if case .gym(let gymActivity) = planElement.activity {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text(gymActivity.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if let description = gymActivity.description {
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Label("\(gymActivity.sets.count) ejercicios", systemImage: "list.bullet")
                        Spacer()
                        if let duration = gymActivity.estimatedDurationMinutes {
                            Label("\(duration) min", systemImage: "clock")
                        }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.14, blue: 0.22))
                .cornerRadius(16)
                .padding(.horizontal, 32)
                
                Button(action: onStart) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Comenzar Entrenamiento")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    let workoutName: String
    let elapsedTime: Int
    
    var body: some View {
        HStack {
            Text(workoutName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Tiempo activo")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(formatTime(elapsedTime))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

// MARK: - Progress Card View
struct ProgressCardView: View {
    let completedSets: Int
    let totalSets: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "target")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    Text("Progreso total")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(completedSets)/\(totalSets) sets")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.2, green: 0.22, blue: 0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(20)
    }
}

// MARK: - Metrics View
struct MetricsViewLocal: View {
    let elapsedTime: Int
    let caloriesBurned: Int
    let currentExercise: Int
    let totalExercises: Int
    
    var body: some View {
        HStack(spacing: 12) {
            MetricCard(
                icon: "clock.fill",
                value: formatTime(elapsedTime),
                label: "Tiempo",
                color: Color(red: 0.3, green: 0.6, blue: 1.0)
            )
            MetricCard(
                icon: "flame.fill",
                value: "\(caloriesBurned)",
                label: "kcal",
                color: Color(red: 1.0, green: 0.5, blue: 0.2)
            )
            MetricCard(
                icon: "dumbbell.fill",
                value: "\(currentExercise)/\(totalExercises)",
                label: "Ejercicio",
                color: Color(red: 0.7, green: 0.4, blue: 0.95)
            )
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct MetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(16)
    }
}

// MARK: - Rest Timer View
struct RestTimerView: View {
    let restTimer: Int
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("DESCANSO")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.8))
                .tracking(1)
            
            Text("\(restTimer)s")
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2))
            
            Text("Prepárate para el siguiente set")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            Button(action: onSkip) {
                Text("Saltar descanso")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.3))
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(red: 0.15, green: 0.1, blue: 0.08))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Current Exercise Card
struct CurrentExerciseCard: View {
    let routineSet: RoutineSet
    let currentSet: Int
    @Binding var property : Int
    let currentExerciseIndex: Int
    let totalExercises: Int
    let completedSets: [Int]
    let totalSetsInExercise: Int
    let isTimerRunning: Bool
    let isResting: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onCompleteSet: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(routineSet.exercise.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Ejercicio \(currentExerciseIndex + 1)/\(totalExercises)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(20)
            }
            
            // Stats del set actual
            if currentSet <= routineSet.series.count {
                let series = routineSet.series[currentSet - 1]
                HStack(spacing: 12) {
                    StatBox(
                        value: "\(currentSet)",
                        label: "Set",
                        color: Color(red: 0.7, green: 0.4, blue: 0.95)
                    )
                    EditableStatBox(
                        value: $property,
                        label: "Reps",
                        color: Color(
                            red: 0.9,
                            green: 0.3,
                            blue: 0.7
                        ),
                        isEditable: true
                    )
                    EditableStatBox(
                        value: $property,
                        label: "kg",
                        color: Color(red: 0.3, green: 0.6, blue: 1.0),
                        isEditable: true
                    )
                }
            }
            
            // Indicadores de sets completados
            HStack(spacing: 6) {
                ForEach(1...totalSetsInExercise, id: \.self) { set in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            completedSets.contains(set) ? Color(red: 0.2, green: 0.8, blue: 0.5) :
                            set == currentSet ? Color(red: 0.7, green: 0.4, blue: 0.95) :
                            Color(red: 0.2, green: 0.22, blue: 0.3)
                        )
                        .frame(height: 6)
                }
            }
            
            // Botones de control
            HStack(spacing: 12) {
                if !isTimerRunning {
                    Button(action: onStart) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 16))
                            Text("Iniciar Rutina")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.2, green: 0.8, blue: 0.5), Color(red: 0.1, green: 0.7, blue: 0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                } else {
                    Button(action: onPause) {
                        HStack(spacing: 8) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 16))
                            Text("Pausar")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.5, blue: 0.2), Color(red: 0.9, green: 0.3, blue: 0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    Button(action: onCompleteSet) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                            Text("Completar Set")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
//                            isResting ? Color(red: 0.2, green: 0.22, blue: 0.3) :
                            LinearGradient(
                                colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(isResting ? .gray : .white)
                        .cornerRadius(16)
                    }
                    .disabled(isResting)
                }
            }
        }
        .padding(20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(24)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(red: 0.15, green: 0.17, blue: 0.25))
        .cornerRadius(12)
    }
}

struct ExerciseListView : View {
    let sets: [RoutineSet]
    let currentIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet")
                    .foregroundColor(Color(red: 0.7, green: 0.4, blue: 0.95))
                Text("Ejercicios restantes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 4)
            
            ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                ExerciseRow(
                    set: set,
                    isCurrent: index == currentIndex,
                    isCompleted: index < currentIndex
                )
            }
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(20)
    }
}

struct ExerciseRow: View {
    let set: RoutineSet
    let isCurrent: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(set.exercise.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text("\(set.series.count) sets")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isCurrent {
                Text("Actual")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.7, green: 0.4, blue: 0.95))
                    .cornerRadius(12)
            }
        }
        .padding(12)
        .background(
            isCurrent ? Color(red: 0.15, green: 0.13, blue: 0.25) :
            isCompleted ? Color(red: 0.08, green: 0.15, blue: 0.12) :
            Color(red: 0.15, green: 0.17, blue: 0.25)
        )
        .cornerRadius(12)
    }
}

struct SetCompleteAnimation: View {
    @State private var overlayOpacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                LottieView(animationName: "success_animation", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                
                Text("¡Vamos si se puede!")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(scale)
            .opacity(overlayOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                overlayOpacity = 1
                scale = 1.0
            }
        }
    }
}

// MARK: - Workout Complete View
struct WorkoutCompleteView: View {
    let totalTime: Int
    let caloriesBurned: Int
    let onDismiss: () -> Void
    
    @State private var bounce = false
    
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Color(red: 0.07, green: 0.09, blue: 0.15))
            }
            .scaleEffect(bounce ? 1.1 : 1.0)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounce)
            .onAppear { bounce = true }
            
            Text("¡Rutina Completada!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("🎉")
                .font(.system(size: 60))
            
            HStack(spacing: 16) {
                CompletionStat(
                    icon: "clock.fill",
                    value: formatTime(totalTime),
                    label: "Tiempo total",
                    color: Color(red: 0.3, green: 0.6, blue: 1.0)
                )
                CompletionStat(
                    icon: "flame.fill",
                    value: "\(caloriesBurned)",
                    label: "Calorías",
                    color: Color(red: 1.0, green: 0.5, blue: 0.2)
                )
            }
            .padding(.horizontal, 20)
            
            Button(action: onDismiss) {
                Text("Finalizar")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct CompletionStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(16)
    }
}

struct EditableStatBox : View {
    @Binding var value: Int
    let label: String
    let color: Color
    let isEditable: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            
            // Usa un TextField si es editable, o solo Text si no lo es
            if isEditable {
                TextField("0", value: $value, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
                    .fixedSize()
                    .frame(minWidth: 50) // Asegurar un tamaño mínimo para el touch
            } else {
                Text(value > 0 ? "\(value)" : "BW")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(red: 0.15, green: 0.17, blue: 0.25))
        .cornerRadius(12)
    }
}
