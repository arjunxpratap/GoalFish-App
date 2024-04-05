import SwiftUI

struct CircularProgressBar: View {
    var progress: CGFloat
    var lineWidth: CGFloat
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.1), style: StrokeStyle(lineWidth: lineWidth))
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 24, weight: .bold))
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: 0.5, lineWidth: 20, color: Color.green)
    }
}
