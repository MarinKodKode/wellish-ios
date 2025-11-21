
import SwiftUI

struct Metrics_StatisticsCard : View {
    
    @ObservedObject var vm = MetricsHistoryViewModel()
    
    let title : String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
            }
            .padding(.horizontal, 16)
            
            if vm.statisticsSummaryLoaded {
                statistics
            }else{
                Metrics_StatisticsCardSkeleton()
            }
        }
    }
    
    var statistics : some View {
        HStack {
            StatisticCardWidget(
                icon: "flame",
                label: "Calorias",
                unit: "Kcal",
                statisticValue: "1200",
                color: .energyFitnessOrange
            )
            
            Spacer()
            
            StatisticCardWidget(
                icon: "clock",
                label: "Tiempo",
                unit: "Horas",
                statisticValue: "52.5",
                color: .primaryBlue
            )
        }
        .padding(.horizontal, 16)
    }
}



