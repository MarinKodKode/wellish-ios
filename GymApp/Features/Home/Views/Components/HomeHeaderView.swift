//
//  HomeHeaderView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//
import SwiftUI
import UIKit

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image("happyman")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(StringConstants.homeViewWelcomeTitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                    Text("Manuel")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 36)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeHeaderView()
}
