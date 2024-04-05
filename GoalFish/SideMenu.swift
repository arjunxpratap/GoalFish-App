import SwiftUI

struct SideMenu: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProSubscriptionView()) {
                    HStack {
                        Image(systemName: "star")
                        Text("Get Pro Subscription")
                    }
                }
                NavigationLink(destination: StoreView()) {
                    HStack {
                        Image(systemName: "cart")
                        Text("Store")
                    }
                }
                NavigationLink(destination: TagsView()) {
                    HStack {
                        Image(systemName: "tag")
                        Text("Tags")
                    }
                }
                NavigationLink(destination: FriendsView()) {
                    HStack {
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                }
                NavigationLink(destination: AchievementsView()) {
                    HStack {
                        Image(systemName: "rosette")
                        Text("Achievements")
                    }
                }
                NavigationLink(destination: NewsView()) {
                    HStack {
                        Image(systemName: "newspaper")
                        Text("News")
                    }
                }
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}
