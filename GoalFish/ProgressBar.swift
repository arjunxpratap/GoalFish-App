import SwiftUI
struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 10))
                .opacity(0.3)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear)
        }
        .frame(width: 150, height: 150)
    }
}
