//
//  AlertManager+.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import Foundation

import Foundation

class AlertViewModel: ObservableObject {
    
    private init() { }
    
    static let shared = AlertViewModel()
    
    @Published var showAlert = false
    @Published var alertType : AlertType  = .none
    @Published var alertMessage = ""
    @Published var acceptAction: (() -> Void)?
    @Published var alertAction: (() -> Void)? = nil
    
    func showErrorAlert(alertType : AlertType, alertMessage : String ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.showAlert = true
            self.alertType = alertType
            self.alertMessage = alertMessage
        }
    }
    
    func showWarningAlert(alertType: AlertType, alertMessage: String, action: @escaping () -> Void = {}) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertType = alertType
            self.alertMessage = alertMessage
            self.alertAction = action
            self.showAlert = true
        }
    }
    
    
    func report(){
        //TODO implement analytics obserber
    }
}

