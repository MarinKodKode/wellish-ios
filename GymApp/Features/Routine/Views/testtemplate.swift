import SwiftUI

struct StickyTimerDemo: View {
    @State private var currentTime: Double = 25.0
    @State private var isPlaying = false
    @State private var timer: Timer?

    @State private var showStickyBar = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Spacer to simulate top content
                    Color.clear
                        .frame(height: 50)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .onAppear {}
                                .onChange(of: proxy.frame(in: .global).minY) { value in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showStickyBar = value < 100
                                    }
                                }
                        })


                    if !showStickyBar {
                        TimerCircleView(
                            currentTime: currentTime,
                            totalTime: 45.0,
                            isPlaying: isPlaying,
                            onToggle: toggleTimer
                        )
                        .transition(.opacity)
                        .animation(.easeInOut, value: showStickyBar)
                    }

                    ForEach(0..<30) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)
                            .overlay(Text("Item \(i)").foregroundColor(.white))
                    }
                }
                .padding(.top, 100)
                .padding(.horizontal)
            }

            if showStickyBar {
                HStack {
                    Text(String(format: "%.1f min", currentTime))
                        .foregroundColor(.white)
                        .font(.headline)

                    Spacer()

                    Button(action: toggleTimer) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color.black.opacity(0.95))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 10)
                .transition(.move(edge: .top))
                .animation(.easeOut, value: showStickyBar)
            }
        }
    }

    private func toggleTimer() {
        isPlaying.toggle()

        if isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if currentTime > 0 {
                    currentTime -= 0.1
                } else {
                    timer?.invalidate()
                    isPlaying = false
                }
            }
        } else {
            timer?.invalidate()
        }
    }
}

// MARK: - Timer Circle
struct TimerCircleView: View {
    let currentTime: Double
    let totalTime: Double
    let isPlaying: Bool
    let onToggle: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                .frame(width: 250, height: 250)

            Circle()
                .trim(from: 0, to: currentTime / totalTime)
                .stroke(
                    LinearGradient(colors: [Color.blue, Color.purple], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 250, height: 250)

            VStack(spacing: 8) {
                Button(action: onToggle) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .clipShape(Circle())
                }

                Text(String(format: "%.1f", currentTime))
                    .foregroundColor(.white)
                    .font(.largeTitle)

                Text("Minutes")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    StickyTimerDemo()
}
