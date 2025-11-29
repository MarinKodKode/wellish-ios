//
//  HomeHeaderView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//
import SwiftUI
import UIKit

struct HomeHeaderView: View {
    
    @StateObject var vm = MainHomeViewModel()
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                AsyncImage(url: vm.profilePhotoURL){ phase in
                    if let image = phase.image{
                        image
                            .resizable()
                            .scaledToFill()
                    }else if phase.error != nil {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    } else{
                        ProgressView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(StringConstants.homeViewWelcomeTitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                    Text(vm.userName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .padding(.top, 36)
        .padding(.bottom, 36)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeHeaderView()
}
