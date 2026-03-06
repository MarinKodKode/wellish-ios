import SwiftUI
import UIKit
struct HomeHeaderView: View {
    @StateObject var vm = MainHomeViewModel()
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(SessionDataManager.shared.photoIdentifier)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
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
