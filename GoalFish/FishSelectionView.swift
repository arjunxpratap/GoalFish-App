import SwiftUI
struct FishSelectionView: View {
    @Binding var selectedFish: String?
    @Binding var isShowing: Bool
    let fishes = ["fish1", "fish2", "fish3", "fish4", "fish5", "fish6", "fish7"] // Update with your actual fish image names
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(fishes, id: \.self) { fish in
                        HStack {
                            VStack(alignment: .leading) {
                                Text((fish))
                                    .font(.headline)
                                Text(randomFact(for: fish))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                selectedFish = fish
                                isShowing.toggle()
                            }) {
                                Image(fish)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding()
                            }
                        }
                    }
                }
                .navigationBarTitle("Select Fish")
                .navigationBarItems(trailing: Button("Close") {
                    isShowing.toggle()
                })
            }
        }
    }
    func randomFact(for fish: String) -> String {
        // Define a dictionary mapping fish names to arrays of random facts
        let fishFacts: [String: [String]] = [
            "fish1": ["Fact 1 about fish 1", "Fact 2 about fish 1", "Fact 3 about fish 1"],
            "fish2": ["Fact 1 about fish 2", "Fact 2 about fish 2", "Fact 3 about fish 2"],
            // Add more fish facts as needed
        ]
        
        // Get the random facts for the given fish
        guard let facts = fishFacts[fish] else { return "" }
        return facts.randomElement() ?? ""
    }

}
