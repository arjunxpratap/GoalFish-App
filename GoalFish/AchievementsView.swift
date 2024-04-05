import SwiftUI

struct AchievementsView: View {
    let totalFocusTime: Int = 100 // Total focus time in minutes
    let badges: [Badge] = [
        Badge(id: 1, name: "Rookie", requiredFocusTime: 100),
        Badge(id: 2, name: "Master", requiredFocusTime: 500),
        Badge(id: 3, name: "Champion", requiredFocusTime: 1000),
        Badge(id: 4, name: "Legend", requiredFocusTime: 2000),
        // Add more badges as needed
    ]
    
    var body: some View {
        VStack {
            Text("Achievements")
                .font(.title)
                .padding()
            
            ForEach(badges) { badge in
                BadgeView(badge: badge, totalFocusTime: totalFocusTime)
                    .padding()
            }
            
            Spacer()
        }
    }
}

struct BadgeView: View {
    let badge: Badge
    let totalFocusTime: Int
    
    var body: some View {
        HStack {
            Text(badge.name)
                .font(.headline)
            
            if totalFocusTime >= badge.requiredFocusTime {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            } else {
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct Badge: Identifiable {
    let id: Int
    let name: String
    let requiredFocusTime: Int // Required focus time in minutes for earning the badge
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
