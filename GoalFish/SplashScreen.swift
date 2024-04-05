// SplashScreen.swift

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo") 
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Text("GoalFish")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
        }
    }
}
