import SwiftUI

struct TimerScreen: View {
    let timerValue: Int
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @Binding var selectedFish: String?
    @Binding var selectedTag: String?
    @Binding var userPoints: Int
    @State private var showingGiveUpAlert = false
    @State private var isTimerFinished = false // Track if timer is finished
    @State private var hasGivenUp = false // Track if the user has given up
    @State private var progress: CGFloat = 1.0 // Progress for progress circle
    @Environment(\.scenePhase) private var scenePhase // Scene phase
    @State private var showingRestartSession = false // Track showing restart session pop-up
    @State private var fishAnimationOffset: CGFloat = 0 // Vertical offset for fish animation
    @State private var fishSizeMultiplier: CGFloat = 1.0 // Multiplier for fish size
    @State private var previousElapsedTime = 0 // Track previous elapsed time
    @State private var isDeadFishVisible = false // Track visibility of dead fish
    @State private var deadFishOffset: CGSize = .zero // Offset for dead fish drop animation

    init(timerValue: Int, selectedFish: Binding<String?>, selectedTag: Binding<String?>, userPoints: Binding<Int>) {
        self.timerValue = timerValue
        _timeRemaining = State(initialValue: timerValue * 60)
        _selectedFish = selectedFish
        _selectedTag = selectedTag
        _userPoints = userPoints
    }

    var body: some View {
        ZStack {
            // Gradient Background
            Image("background") // Assuming "background.png" is the name of your PNG image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(1.0) // Adjust opacity as needed
                .blur(radius: 5)
            
            VStack {
                // Display selected tag activity
                if let selectedTag = selectedTag {
                    Text("You're now doing \(selectedTag), FOCUS")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.top, 50) // Adjust top padding
                }
                
                Spacer() // Push other content to the bottom
                
                // Fish Pot with Timer
                ZStack {
                    Image("fish_pot") // Replace "fish_pot" with the name of your fish pot image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 500) // Adjust size as needed
                        .shadow(radius: 10)
                    
                    // Circular Progress Bar
                    CircularProgressView(progress: .constant(Double(progress)))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90)) // Start from the top
                        .padding(40) // Adjust position to center
                    
                    // Dead Fish
                    if isDeadFishVisible {
                        Image("dead_fish")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .offset(deadFishOffset)
                            .animation(.interpolatingSpring(mass: 0.5, stiffness: 100, damping: 10, initialVelocity: 0))
                    } else {
                        // Animated Fish
                        if let selectedFish = selectedFish {
                            Image(selectedFish)
                                .resizable()
                                .frame(width: 100 * fishSizeMultiplier, height: 100 * fishSizeMultiplier)
                                .clipShape(Circle())
                                .offset(y: 20 + fishAnimationOffset)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true))
                                .onAppear {
                                    startFishAnimation()
                                }
                        }
                    }
                }
                
                // Countdown Timer
                VStack {
                    Text("\(timeRemaining / 60) min \(timeRemaining % 60) sec") // Display remaining time in the same style as flip clock animation
                        .font(.system(size: 30)) // Adjust font size
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                        .animation(.default)
                }
                
                // Give up button
                Button(action: {
                    showingGiveUpAlert = true
                }) {
                    Text("Give up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50) // Adjust bottom padding
            }
        }
        .onAppear {
            timeRemaining = timerValue * 60
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // App becomes active, resume timer
                startTimer()
            case .inactive, .background:
                // App becomes inactive or moves to background, pause timer
                timer?.invalidate()
            @unknown default:
                break
            }
        }
        .alert(isPresented: $showingGiveUpAlert) {
            Alert(title: Text("Are you sure?"), message: Text("Your fish will die if you exit."), primaryButton: .destructive(Text("Yes")) {
                // Handle giving up
                hasGivenUp = true
                timer?.invalidate()
                isTimerFinished = true
                userPoints -= 1 // Deduct points for giving up
                isDeadFishVisible = true // Show dead fish
                dropDeadFish() // Animate dead fish drop
            }, secondaryButton: .cancel())
        }
        .sheet(isPresented: $isTimerFinished) {
            if showingRestartSession {
                RestartSessionView(showingRestartSession: $showingRestartSession)
            } else {
                ResultScreen(focusTime: calculateElapsedTime(),
                             remainingTime: calculateRemainingTime(),
                             hasGivenUp: hasGivenUp,
                             userPoints: $userPoints)
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
        .navigationBarTitle("", displayMode: .inline) // Empty title
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = CGFloat(timeRemaining) / CGFloat(timerValue * 60)
                
                // Check if it's time to increase fish size
                let elapsedTime = timerValue * 60 - timeRemaining
                let quarterTime = timerValue * 15 // 1/4 of the selected time
                if elapsedTime % quarterTime == 0 && elapsedTime != previousElapsedTime {
                    fishSizeMultiplier += 0.1 // Increase fish size by 10%
                    previousElapsedTime = elapsedTime
                }
            } else {
                timer.invalidate()
                isTimerFinished = true
                userPoints += 10 // Add points for completing the task
                isDeadFishVisible = true // Show dead fish
                dropDeadFish() // Animate dead fish drop
            }
        }
    }

    private func startFishAnimation() {
        withAnimation(Animation.linear(duration: Double(timerValue * 60))) {
            fishAnimationOffset = -25 // Set initial offset for the middle of the timer
        }
    }
    
    // Animate dead fish drop
    private func dropDeadFish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                deadFishOffset.height = 100 // Adjust the height for the drop animation
            }
        }
    }
    
    // Function to calculate elapsed time
    private func calculateElapsedTime() -> Int {
        let elapsedTime = timerValue * 60 - timeRemaining
        return max(elapsedTime, 0)
    }
    
    // Function to calculate remaining time
    private func calculateRemainingTime() -> Int {
        return max(timeRemaining, 0)
    }
}

struct CircularProgressView: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.clear, lineWidth: 10)
                .frame(width: 280, height: 280)
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: CGFloat(progress))
                        .stroke(Color.white.opacity(0.7), lineWidth: 10)
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90)) // Rotate clockwise to start at 12 o'clock position
                )
                .animation(.linear(duration: 1)) // Adjust animation duration
            
            // Add any additional content inside the circular progress bar if needed
        }
    }
}

struct RestartSessionView: View {
    @Binding var showingRestartSession: Bool
    
    var body: some View {
        VStack {
            Text("Session Ended")
                .font(.title)
                .foregroundColor(.black)
                .padding()
            Button(action: {
                showingRestartSession = false
            }) {
                Text("Restart Session")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}
