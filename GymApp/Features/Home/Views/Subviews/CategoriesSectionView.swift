//
//  CategoriesSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//

import SwiftUI

public struct  CategoriesSectionView :  View {
        
    public var body : some View {
        VStack(alignment: .leading, spacing: 16) {
          
            SectionBarTitle(title: "Categorias", icon :"arrow.right")
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 12){
                    CategorieCard()
                    CategorieCard()
                    CategorieCard()
                    CategorieCard()
                    CategorieCard()
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
        }

    }
}

public struct CategorieCard : View {
        
    public var body  : some View {
        ZStack {
            
            VStack(spacing: 8){
                HStack(alignment: .center){
                    Text("Home\nWorkout") // title
                        .font(.system(size: 28))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 16)
                
                HStack(alignment: .center, spacing: 20){
                    VStack(alignment: .leading) {
                        HStack{
                            Text("4.9") // rating metric
                                .font(.system(size: 14))
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        Text("12 routines") // routines / exercises
                            .font(.system(size: 12))
                    }
                    Image(systemName: "house.fill") // icon
                        .resizable()
                        .frame(width: 52, height: 52)
                }
                .padding(.leading, 16)
                .frame(width: 160, alignment: .leading)
            }
        }
        .frame(width: 160, height: 160)
        .background(LinearGradient.outdoorRunning) // gradient
        .cornerRadius(16)
    }
}


#Preview {
    CategoriesSectionView()
}
