import SwiftUI
import GameKit

struct ContentView: View {
    @State private var selectedValue: Double = 10 // Default selected value set to 10 minutes
    @State private var isTiming = false
    @State private var timeRemaining: Double = 0
    @State private var timer: Timer?
    @State private var isShowingFishSelection = false
    @State private var selectedFish: String? = nil
    @State private var isShowingTagList = false
    @State private var selectedTag: String? = nil
    @State private var isSideMenuOpen = false
    @AppStorage("userPoints") private var userPoints = 0 // Track user points
    let tagOptions = ["Study", "Work", "Meditate", "Exercise"]
    
    @State private var isFocusModeActive = false // Track focus mode state
    @State private var isShowingTagSelectionDialog = true // Track showing tag selection dialog
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background") // Assuming "background.png" is the name of your PNG image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(2) // Adjust opacity as needed
                    .blur(radius: 1)
                
                VStack {
                    HStack {
                        Text("Shells").font(.title3)
                            .offset(y:180)
                            .bold()
                            .foregroundColor(.white)
                        Text("🐚: \(userPoints)") // Display user points
                            .font(.title3)
                            .padding()
                            .foregroundColor(.white) // White text color for points
                            .offset(y:180)
                    }
                    
                    Button(action: {
                        isShowingTagList.toggle()
                    }) {
                        HStack {
                            Text(selectedTag ?? "Select Tag")
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                    .padding(.top, 20) // Adjusted position of tag option
                    
                    ZStack {
                        Image("fish_pot") // Replace "fish_pot" with the name of your fish pot image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 450) // Adjust size as needed
                            .shadow(radius: 10)
                        
                        // Display selected fish inside the fish pot
                        if let selectedFish = selectedFish {
                            Image(selectedFish)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .offset(y: -20)
                        }
                    }
                    
                    // Flip Clock Animation
                    VStack {
                        Text("\(Int(selectedValue)) min") // Display selected time as flip clock animation
                            .font(.system(size: 30)) // Reduce font size
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                            .padding(.bottom, 20)
                            .animation(.default)
                    }
                    .offset(y: -10) // Adjust vertical position
                    
                    HStack {
                        Slider(value: $selectedValue, in: 1.0...120.0, step: 5.0)
                            .disabled(isTiming || isFocusModeActive) // Disable slider during timing or focus mode
                            .accentColor(.white)
                            .offset(y:-30)
                        Spacer()
                        
                        // Conditional Navigation Link to TimerScreen
                        if selectedFish != nil {
                            NavigationLink(destination: TimerScreen(timerValue: Int(TimeInterval(Int(selectedValue))), selectedFish: $selectedFish, selectedTag: $selectedTag, userPoints: $userPoints)) {
                                Text("Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green) // Always green
                                    .cornerRadius(10)
                                    .padding(.trailing)
                                    .offset(y: -30)
                            }
                        } else {
                            Text("Start")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray) // Disabled state
                                .cornerRadius(10)
                                .padding(.trailing)
                                .disabled(true)
                                .offset(y: -30)
                        }
                    }
                    .padding()
                }
                
                // Circular Progress Bar
                CircularProgress(progress: $selectedValue) // Use selectedValue as progress
                    .frame(width: 250, height: 250) // Increase size of circular progress bar
                    .padding(.top,-15)
                
                // Custom popover menu for tag selection
                if isShowingTagList {
                    VStack {
                        VStack(spacing: 10) {
                            ForEach(tagOptions, id: \.self) { tag in
                                Button(action: {
                                    selectedTag = tag
                                    isShowingTagList.toggle()
                                    isShowingFishSelection.toggle() // Show fish selection dialog after selecting the tag
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(getTagColor(tag: tag)) // Get different colors for different tags
                                            .frame(width: 10, height: 10)
                                        Text(tag)
                                    }
                                    .foregroundColor(.black)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    }
                }
                
            }
            .navigationBarTitle("Achieve Your Goal")
            .foregroundColor(.white)
            .navigationBarItems(
                leading: Button(action: {
                    isSideMenuOpen.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                        .foregroundColor(.white)
                },
                trailing: Button(action: {
                    isShowingFishSelection.toggle()
                }) {
                    Image(systemName: "fish.fill")
                        .imageScale(.large)
                        .foregroundColor(.white) // Set navigation bar item color
                }
            )
            .sheet(isPresented: $isShowingFishSelection) {
                FishSelectionView(selectedFish: $selectedFish, isShowing: $isShowingFishSelection)
            }
        }
        .background(Color.clear) // Set background color
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isSideMenuOpen) {
            SideMenu()
        }
        .onAppear {
            authenticatePlayer()
        }
    }
    
    private func getTagColor(tag: String) -> Color {
        switch tag {
        case "Study":
            return Color.blue
        case "Work":
            return Color.green
        case "Meditate":
            return Color.orange
        case "Exercise":
            return Color.red
        default:
            return Color.gray
        }
    }
    
    // Function to start focus mode
    private func startFocusMode() {
        isFocusModeActive = true
        // Optionally disable interactive elements or take other actions
    }
    
    // Function to authenticate the player with Game Center
    private func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let error = error {
                print("Game Center authentication error: \(error.localizedDescription)")
            } else if let viewController = viewController {
                // Show the Game Center login view controller
                UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
            } else if GKLocalPlayer.local.isAuthenticated {
                print("Game Center authentication successful.")
            } else {
                print("Player is not signed in to Game Center.")
            }
        }
    }
}

struct CircularProgress: View {
    var progress: Binding<Double>
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress.wrappedValue / 120)) // Assuming the maximum value of selectedValue is 120
                .stroke(Color.green, lineWidth: 20) // Increased lineWidth
                .rotationEffect(.degrees(-90))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
