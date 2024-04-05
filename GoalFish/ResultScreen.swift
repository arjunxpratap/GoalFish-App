import SwiftUI

struct ResultScreen: View {
    let focusTime: Int
    let remainingTime: Int
    let hasGivenUp: Bool
    @Binding var userPoints: Int
    @State private var showingRestartPopup = false

    var body: some View {
        ZStack {
            // Aquatic Background
            Color.blue
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Image("underwater-background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.5)
                )
            
            VStack {
                // Task Result
                VStack {
                    Text("Task Result")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(hasGivenUp ? .orange : .green)
                        .padding(.bottom, 20)
                    
                    // Display earned or lost points
                    Text(hasGivenUp ? "You lost 1 🐚" : "You earned 10 🐚")
                        .foregroundColor(hasGivenUp ? .red : .green)
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    // Display message based on completion or giving up
                    Text(hasGivenUp ? "Oops! You'll achieve your goal next time." : "Congratulations! You completed the task successfully.")
                        .foregroundColor(hasGivenUp ? .orange : .green)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .padding(.top, 50)
                
                // Time Remaining Text
                Text("Time Remaining: \(remainingTime) seconds")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Focused Time and Remaining Time Visualization
                RadialGaugeChart(remainingTime: remainingTime, focusTime: focusTime)
                    .padding(.bottom, 20)
                
                // Restart and Exit Buttons
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingRestartPopup.toggle()
                    }) {
                        Text("Restart")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 30)
        }
        .navigationBarTitle("Task Result")
        .navigationBarHidden(true) // Hide the navigation bar
        .sheet(isPresented: $showingRestartPopup) {

        }
    }
}
