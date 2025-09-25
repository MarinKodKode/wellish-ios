//
//  RoutineStatisticsRowView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/09/25.
//

import SwiftUI

struct RoutineStatisticsRowView: View {
    
    let size : CGFloat
    let gap: CGFloat
    var numberOfStats : Int? = 3
    var alignTo : Alignment = .center
    
    var body: some View {
        HStack(spacing : gap) {
            HStack(spacing: 4) {
                Image(systemName: "dumbbell")
                    .foregroundColor(.white)
                    .font(.system(size: size))
                Text("8 exercises")
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .foregroundColor(.white)
                    .font(.system(size: size))
                Text("90min")
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(.white)
            }
            
            if numberOfStats == 3 {
                HStack(spacing: 4) {
                    Image(systemName: "flame")
                        .foregroundColor(.white)
                        .font(.system(size: size))
                    Text("1,200kcal")
                        .font(.system(size: size, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: self.alignTo)
    }
}

#Preview {
    RoutineStatisticsRowView(size: 14, gap: 24)
}
