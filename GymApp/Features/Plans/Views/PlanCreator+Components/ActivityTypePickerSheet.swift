//
//  ActivityTypePickerSheet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import SwiftUI

struct ActivityTypePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let day: Int
    @ObservedObject var viewModel: PlanCreatorViewModel
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
