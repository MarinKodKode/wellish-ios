//
//  ProfileView_Section_Header.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/12/25.
//

import Foundation
import SwiftUI

struct ProfileView_Header_Section : View {
    
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Button(action: {
                vm.displayAvatarPickerSheet = true
            }) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    vm.profileIconColor,
                                    vm.profileIconColor.opacity(0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(vm.selectedProfileIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 89, height: 89)
                                .cornerRadius(90)
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "FFD700"),
                                            Color(hex: "FF6B6B"),
                                            Color(hex: "4E73DF")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                }
            }
            
            // Bio and Tags Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(vm.username)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                    
                    Spacer()
                    
                    Button(action: {
//                        showEditSheet = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .fill(Color.fitnessTextSecondary.opacity(0.2))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.fitnessTextPrimary)
                        }
                    }
                }
                
                Text(vm.bio_description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                FlowLayouts(spacing: 6) {
                    ForEach(vm.user_tags, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
}


#Preview {
    ProfileView_Header_Section()
}
