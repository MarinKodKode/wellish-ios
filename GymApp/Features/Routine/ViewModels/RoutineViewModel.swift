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

}
