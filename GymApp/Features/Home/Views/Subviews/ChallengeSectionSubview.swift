import SwiftUI

struct ChallengeSectionSubview: View {
    
    let challenge: [ChallengeCardModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringConstants.plansSubtitle)
                .font(.title2.bold())
                .foregroundColor(.fitnessTextPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(challenge.indices, id: \.self) { index in
                        Home_ChallengeCard(challenge: challenge[index])
                            .padding(.leading, index == 0 ? 16 : 8)
                            .padding(.trailing, index == challenge.count - 1 ? 16 : 8)
                    }
                }
            }
        }
    }
}
