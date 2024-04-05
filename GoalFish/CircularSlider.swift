import SwiftUI

struct CircularSlider: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 20))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
            
            Text("\(Int(progress * 100))%")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}
