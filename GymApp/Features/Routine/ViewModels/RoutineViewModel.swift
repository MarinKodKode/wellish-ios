import Foundation
import Combine
import SwiftUI

@MainActor

public final class RoutineViewModel : ObservableObject {
    
    @Published public var routine : Routine
    
    //UI State
    
    @Published public var isSaving : Bool = false
    @Published public var isLoading : Bool = false
    @Published public var errorMessage : String?
    @Published var error : ErrorWrapper?
    @Published var savedRoutines : [Routine] = []
    @Published var tagsInput : String = ""
    
    //Connection Status
    @Published public var isOnline : Bool = true
    @Published public var lastSyncDate : Date?
    
    let repository : RoutineRepositoryProtocol
    let firestoreService = RoutineFirestoreService()
    let localStorageService = RoutineLocalStorageService()
    
    public init(
        routine : Routine = Routine(
            name : StringConstants.routineNewRoutine
        ),
        repository : RoutineRepositoryProtocol = MockRoutineRepository()
    ){
        self.routine = routine
        self.repository = repository
    }
    
    public var isValidName : Bool {
        !routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var canSave : Bool {
        isValidName && !routine.sets.isEmpty && !isSaving
    }
    
    // MARK: - Validation
    
    /// Validates routine and returns error if they are
    
    public func validateRoutine() -> (isValid : Bool, errors : [String]){
        
        var errors : [String] = []
        
        //Validates if Name is empty
        if routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name cannot be empty")
        }
        
        //Validates at least one exercise
        if routine.sets.isEmpty {
            errors.append("Need at least one exercise")
        }
        
        //Validates at least one serie in each exercise
        for (index, set) in routine.sets.enumerated(){
            if set.series.isEmpty{
                errors.append("\(set.exercise.name) must have at least one serie")
            }
        }
        return (errors.isEmpty, errors)
    }
    
    
    //MARK: -  CRUD Helpers
    
    public func addSet(with exercise : Exercise){
        let newSet = RoutineSet(exercise: exercise)
        routine.sets.append(newSet)
        routine.updatedAt = Date()
    }
    
    public func removeSet(at index : Int){
        guard routine.sets.indices.contains(index) else { return }
        routine.sets.remove(at: index)
        routine.updatedAt = Date()
    }
    
    public func addSerie(toSetAt setIndex : Int) {
        guard routine.sets.indices.contains(setIndex) else { return }
        routine.sets[setIndex].series.append(Serie())
        routine.updatedAt = Date()
    }
    
    public func removeSerie(at serieIndex : Int, inSet setIndex : Int){
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series.remove(at: serieIndex)
        routine.updatedAt = Date()
    }
    
    public func updateSerie(_ serie : Serie, at serieIndex : Int, inSet setIndex : Int){
        guard routine.sets.indices.contains(setIndex),
              routine.sets[setIndex].series.indices.contains(serieIndex) else { return }
        routine.sets[setIndex].series[serieIndex] = serie
        routine.updatedAt = Date()
    }
    
    //MARK: - Metrics
    
    public var estimatedVolumeKg : Double {
        routine.estimatedVolumeKg
    }
    
    public var totalReps : Int {
        routine.totalReps
    }
    
    // MARK: - Templates & tags helpers
    
    public func addTag(_ tag : String){
        let t = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, !routine.tags.contains(t) else { return }
        routine.tags.append(t)
        routine.updatedAt = Date()
    }
    
    public func removeTag(_ tag : String ){
        routine.tags.removeAll{ $0 == tag }
        routine.updatedAt = Date()
    }
    
    // MARK: - Auto-complete fields
    
    /// Fills some important gaps before saving routine
    
    public func prepareRoutineForSave(){
        //Update timestamp
        routine.updatedAt = Date()
        
        //Auto-fill worked muscles
        if routine.musclesWorked?.isEmpty ?? true {
            let allMuscles = Set(routine.sets.flatMap{ $0.exercise.muscles })
            routine.musclesWorked = Array(allMuscles).sorted()
        }
        
        //Calculate stimated duration if empty
        if routine.estimatedDurationMinutes == nil {
            routine.estimatedDurationMinutes = calculateEstimatedDuration()
        }
        
        // Asignar creator si está disponible (descomentar cuando tengas Firebase Auth)
        // if routine.creator == nil {
        //     routine.creator = Auth.auth().currentUser?.uid
        // }
        
        // Si no hay categoría, tomar del primer ejercicio
        if routine.category == nil || routine.category?.isEmpty ?? true {
            routine.category = routine.sets.first?.exercise.category
        }
        
        // Grupo muscular afectado (tomar el más común)
        if routine.muscularGroupAffected == nil {
            routine.muscularGroupAffected = determinePrimaryMuscularGroup()
        }
    }
    
    //Calculate estimated duration of each routine
    private func calculateEstimatedDuration() -> Int {
        let totalSeries = routine.sets.reduce(0) { $0 + $1.series.count}
        let avgTimePerSerie = 45
        
        let totalRestTime = routine.sets.reduce(0) { total, set in
            let restTime = set.restBetweenSeriesSeconds ?? 90
            let seriesCount = max(0, set.series.count - 1)
            return total + (restTime * seriesCount)
        }
        
        let totalSeconds = (totalSeries * avgTimePerSerie) + totalRestTime
        return max(1, (totalSeconds + 59) / 60)
    }
    
    // Determine main muscular group
    
    private func determinePrimaryMuscularGroup() -> String {
        let muscles = routine.sets.flatMap{ $0.exercise.muscles}
        guard !muscles.isEmpty else { return "General" }
        
        var muscleCount : [String : Int] = [:]
        muscles.forEach { muscle in
            muscleCount[muscle, default: 0] += 1
        }
        
        return muscleCount.max(by: { $0.value < $1.value})?.key ?? muscles.first ?? "General"
    }
    
    // MARK: - Save to Firebase
    // Guarda la rutina directamente en Firebase Firestore
    
    
    
    // MARK: - Update in Firebase

    //Updates an existant routine in Firebase
    
    public func updateInFirebase() async -> Bool {
        guard canSave else {
            errorMessage = "Please provide a name and an exercise"
            return false
        }
        
        let validation = validateRoutine()
        
        if !validation.isValid {
            errorMessage = validation.errors.joined(separator: "\n")
            return false
        }
        
        isSaving = true
        errorMessage = nil
        
        prepareRoutineForSave()
        
        do {
            try await firestoreService.updateRoutine(routine)
            isSaving = false
            print("Routine updated successfully.")
            return true
        }catch{
            errorMessage = "Error updating routine: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
    
    // MARK: - Delete from Firebase
    
    public func deleteFromFirebase() async -> Bool {
        isSaving = true
        errorMessage = nil
        
        do {
            try await firestoreService.deleteRoutine(id: routine.id)
            isSaving = false
            return true
        }catch {
            errorMessage = "Error deleting routine - \(error.localizedDescription)"
            print("Erro : \(String(describing: errorMessage))")
            return false
        }
    }
}
