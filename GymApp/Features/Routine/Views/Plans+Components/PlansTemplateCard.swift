//
//  PlansTemplateCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/09/25.
//

import SwiftUI

struct TemplateCard: View {
    let template: RoutineTemplate
    var action: () -> Void
    
    @State private var imageLoadFailed = false
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(template.name)
                        .font(.system(size: 24, weight: .bold))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(template.description)
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Label("\(template.estimatedDuration)min", systemImage: "clock")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack{
                        Label("\(template.difficulty.rawValue)", systemImage: template.imageName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(template.difficulty.color.opacity(0.8))
                        .cornerRadius(8)
                        
                    }
                    .padding(.bottom, 12)
                
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.6)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            }
        }
        .frame(width: 280, height: 200)
        .cornerRadius(16)
        .clipped()
        .onTapGesture(perform: action)
    }
    
    
    @ViewBuilder
    private var backgroundView: some View {
        if let imageURL = template.imageURL, !imageURL.isEmpty, !imageLoadFailed {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 280, height: 200)
                        .aspectRatio(contentMode: .fit)
                        .overlay(Color.backgroundPrimary.opacity(0.6))
                case .failure(_):
                    gradientBackground
                case .empty:
                    gradientBackground
                @unknown default:
                    gradientBackground
                }
            }
        } else {
            gradientBackground
        }
    }
    
    private var gradientBackground: some View {
        LinearGradient(
            colors: [
                .primaryFitnessBlue.opacity(0.8),
                .premiumFitnessPurple.opacity(0.9),
                .infoFitnessCyan.opacity(0.7)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}


// MARK: - Previews

struct TemplatePlansView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.light)
            
            PlansView(vm: RoutineViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
