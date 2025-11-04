import SwiftUI
import Lottie

struct ExerciseLocal: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
    let weight: Int
    let restTime: Int
}

struct WorkoutRoutineViewLocal: View {
    @StateObject private var viewModel = WorkoutViewModel()
    
    let element : PlanElement
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.07, green: 0.09, blue: 0.15)
                .ignoresSafeArea()
            
            if viewModel.showWorkoutComplete {
                WorkoutCompleteView(
                    totalTime: viewModel.elapsedTime,
                    caloriesBurned: viewModel.caloriesBurned
                )
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        HeaderView(elapsedTime: viewModel.elapsedTime)
                        
                        ProgressCardView(
                            completedSets: viewModel.completedSetsCount,
                            totalSets: viewModel.totalSets,
                            progress: viewModel.progress
                        )
                        
                        MetricsViewLocal(
                            elapsedTime: viewModel.elapsedTime,
                            caloriesBurned: viewModel.caloriesBurned,
                            currentExercise: viewModel.currentExerciseIndex + 1
                        )
                        
                        if viewModel.isResting {
                            RestTimerView(restTimer: viewModel.restTimer)
                        }
                        
                        CurrentExerciseCard(
                            exercise: viewModel.currentExercise,
                            currentSet: viewModel.currentSet,
                            currentExerciseIndex: viewModel.currentExerciseIndex,
                            completedSets: viewModel.completedSets[viewModel.currentExerciseIndex] ?? [],
                            isTimerRunning: viewModel.isTimerRunning,
                            isResting: viewModel.isResting,
                            onStart: viewModel.startWorkout,
                            onPause: viewModel.pauseWorkout,
                            onCompleteSet: viewModel.completeSet
                        )
                        
                        ExerciseListView(
                            exercises: viewModel.exercises,
                            currentIndex: viewModel.currentExerciseIndex
                        )
                        
                        if viewModel.isTimerRunning {
                            Button("Saltar ejercicio") {
                                viewModel.skipExercise()
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
            if viewModel.showSetComplete {
                SetCompleteAnimation()
            }
        }
    }
}

struct HeaderView: View {
    let elapsedTime: Int
    
    var body: some View {
        HStack {
            Text("Upper Body Workout")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
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

struct MetricsViewLocal : View {
    let elapsedTime: Int
    let caloriesBurned: Int
    let currentExercise: Int
    
    var body: some View {
        HStack(spacing: 12) {
            MetricCard(icon: "clock.fill", value: formatTime(elapsedTime), label: "Tiempo", color: Color(red: 0.3, green: 0.6, blue: 1.0))
            MetricCard(icon: "flame.fill", value: "\(caloriesBurned)", label: "kcal", color: Color(red: 1.0, green: 0.5, blue: 0.2))
            MetricCard(icon: "dumbbell.fill", value: "\(currentExercise)/8", label: "Ejercicio", color: Color(red: 0.7, green: 0.4, blue: 0.95))
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

struct RestTimerView: View {
    let restTimer: Int
    
    var body: some View {
        VStack(spacing: 10) {
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

struct CurrentExerciseCard: View {
    let exercise: ExerciseLocal
    let currentSet: Int
    let currentExerciseIndex: Int
    let completedSets: [Int]
    let isTimerRunning: Bool
    let isResting: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onCompleteSet: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(exercise.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Ejercicio \(currentExerciseIndex + 1)/8")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(20)
            }
            
            HStack(spacing: 12) {
                StatBox(value: "\(currentSet)", label: "Set", color: Color(red: 0.7, green: 0.4, blue: 0.95))
                StatBox(value: "\(exercise.reps)", label: "Reps", color: Color(red: 0.9, green: 0.3, blue: 0.7))
                StatBox(value: exercise.weight > 0 ? "\(exercise.weight)" : "BW", label: "kg", color: Color(red: 0.3, green: 0.6, blue: 1.0))
            }
            
            HStack(spacing: 6) {
                ForEach(1...exercise.sets, id: \.self) { set in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            completedSets.contains(set) ? Color(red: 0.2, green: 0.8, blue: 0.5) :
                            set == currentSet ? Color(red: 0.7, green: 0.4, blue: 0.95) : Color(red: 0.2, green: 0.22, blue: 0.3)
                        )
                        .frame(height: 6)
                }
            }
            
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

struct ExerciseListView: View {
    let exercises: [ExerciseLocal]
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
            
            ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseRow(
                    exercise: exercise,
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
    let exercise: ExerciseLocal
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
                Text(exercise.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text("\(exercise.sets) sets × \(exercise.reps) reps" + (exercise.weight > 0 ? " @ \(exercise.weight)kg" : ""))
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
    @State private var animationProgress: CGFloat = 0
    @State private var overlayOpacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                // Lottie Animation View
                LottieView(animationName: "success_animation", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                    .onAppear {
                        animationProgress = 1
                    }
                Text("!Vamos si se puede!")
                    .font(.system(size: 35, weight: .bold))
            }
            
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                overlayOpacity = 1
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    overlayOpacity = 0
                    scale = 1.1
                }
            }
        }
    }
}

struct WorkoutCompleteView: View {
    let totalTime: Int
    let caloriesBurned: Int
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
                CompletionStat(icon: "clock.fill", value: formatTime(totalTime), label: "Tiempo total", color: Color(red: 0.3, green: 0.6, blue: 1.0))
                CompletionStat(icon: "flame.fill", value: "\(caloriesBurned)", label: "Calorías", color: Color(red: 1.0, green: 0.5, blue: 0.2))
            }
            .padding(.horizontal, 20)
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

struct WorkoutRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRoutineViewLocal()
    }
}

// MARK: - EditableStatBox (Nuevo Componente)
struct EditableStatBox: View {
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


struct CurrentExerciseCardex: View {
    // Propiedades existentes
    let exercise: ExerciseLocal
    let currentSet: Int
    let currentExerciseIndex: Int
    let completedSets: [Int] // Sets completados (solo índices)
    let isTimerRunning: Bool
    let isResting: Bool
    
    // Acciones existentes
    let onStart: () -> Void
    let onPause: () -> Void
    
    // NUEVA ACCIÓN: Pasa los datos REALES de la serie completada
    let onCompleteSet: (Int, Int) -> Void // (actualReps, actualWeight)
    
    // NUEVOS ESTADOS para capturar la entrada del usuario
    @State private var actualReps: Int
    @State private var actualWeight: Int
    
    // Inicializador para configurar los estados con los valores planeados
    init(
        exercise: ExerciseLocal,
        currentSet: Int,
        currentExerciseIndex: Int,
        completedSets: [Int],
        isTimerRunning: Bool,
        isResting: Bool,
        onStart: @escaping () -> Void,
        onPause: @escaping () -> Void,
        onCompleteSet: @escaping (Int, Int) -> Void
    ) {
        self.exercise = exercise
        self.currentSet = currentSet
        self.currentExerciseIndex = currentExerciseIndex
        self.completedSets = completedSets
        self.isTimerRunning = isTimerRunning
        self.isResting = isResting
        self.onStart = onStart
        self.onPause = onPause
        self.onCompleteSet = onCompleteSet
        
        // Inicializa el State con los valores del plan para el set actual
        _actualReps = State(initialValue: exercise.reps)
        _actualWeight = State(initialValue: exercise.weight)
    }

    var body: some View {
        VStack(spacing: 20) {
            // ... (Header y Barritas de sets existentes) ...
            
            // Sección de Datos de la Serie (Ajustada a inputs)
            HStack(spacing: 12) {
                StatBox(value: "\(currentSet)", label: "Set", color: Color(red: 0.7, green: 0.4, blue: 0.95))
                
                // CAMPO 1: REPETICIONES REALES
                EditableStatBox(
                    value: $actualReps,
                    label: "Reps",
                    color: Color(red: 0.9, green: 0.3, blue: 0.7),
                    isEditable: isTimerRunning && !isResting // Solo editar cuando está activo
                )
                
                // CAMPO 2: PESO REAL
                EditableStatBox(
                    value: $actualWeight,
                    label: "kg",
                    color: Color(red: 0.3, green: 0.6, blue: 1.0),
                    isEditable: isTimerRunning && !isResting
                )
            }
            
            // ... (Barra de progreso de Sets existente) ...

            HStack(spacing: 12) {
                if !isTimerRunning {
                    // ... (Botón Iniciar Rutina existente) ...
                } else {
                    // ... (Botón Pausar existente) ...
                    
                    // BOTÓN COMPLETAR SET: Llama al closure con los datos reales
                    Button(action: {
                        // Pasar el valor real de los campos @State
                        onCompleteSet(actualReps, actualWeight)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                            Text("Completar Set")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        // ... (Estilos existentes) ...
                    }
                    .disabled(isResting)
                }
            }
        }
        .padding(20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(24)
        // Restablece los inputs al cambiar de ejercicio
        .id(exercise.id)
    }
}
