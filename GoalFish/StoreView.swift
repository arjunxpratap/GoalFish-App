import SwiftUI

struct StoreItem {
    let name: String
    let price: Int
    let imageName: String
}

struct StoreView: View {
    let storeItems: [StoreItem] = [
        StoreItem(name: "Fish 1", price: Int.random(in: 10...50), imageName: "fish1"),
        StoreItem(name: "Fish 2", price: Int.random(in: 10...50), imageName: "fish2"),
        StoreItem(name: "Fish 3", price: Int.random(in: 10...50), imageName: "fish3"),
        StoreItem(name: "Fish 4", price: Int.random(in: 10...50), imageName: "fish4"),
        StoreItem(name: "Fish 5", price: Int.random(in: 10...50), imageName: "fish5"),
        StoreItem(name: "Fish 6", price: Int.random(in: 10...50), imageName: "fish6"),
        StoreItem(name: "Fish 7", price: Int.random(in: 10...50), imageName: "fish7"),
    ]
    
    @State private var userPoints = 100 // User's shell points
    
    var body: some View {
        VStack {
            Text("Available Fishes")
                .font(.title)
                .padding()
            
            List(storeItems, id: \.name) { item in
                HStack {
                    Image(item.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(item.name)
                    Spacer()
                    Text("\(item.price) 🐚") // Display item price in shell points
                }
                .padding()
            }
            
            Text("Your Shell Points: \(userPoints)")
                .padding()
            
            Spacer()
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
