//
//  AlertManagerView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/11/25.
//

import SwiftUI

struct AlertManagerView: View {
    
    @EnvironmentObject var alertVM: AlertViewModel
    
    var body: some View {
        VStack {}
            .onAppear {
                
            }
            .if(alertVM.showAlert, transform: { view in
                view
                    .alert(isPresented: $alertVM.showAlert) {
                        switch alertVM.alertType {
                        case .confirmLogout:
                            Alert(
                                title: Text(StringConstants.atention),
                                message: Text(StringConstants.warningLoginOut),
                                primaryButton:
                                        .cancel(Text(StringConstants.cancel), action: {
                                }),
                                secondaryButton: .default(Text("Cerrar sesión"), action: {
                                    alertVM.alertAction?()
                                    alertVM.alertAction = nil
                                })
                                )
                        case .none:
                            Alert(
                                title: Text("Atención"),
                                message: Text(""),
                                dismissButton: .default(Text("Aceptar"), action: {
                                    
                                }))
                        }
                    }
            }
            )
    }
}

#Preview {
    AlertManagerView()
}
