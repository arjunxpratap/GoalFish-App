import SwiftUI

struct RadialGaugeChart: View {
    let remainingTime: Int
    let focusTime: Int
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 20)
                    .frame(width: 200, height: 200)
                
                ArcShape(startAngle: .degrees(0), endAngle: .degrees(Double(remainingTime) / Double(focusTime + remainingTime) * 360))
                    .stroke(Color.green, lineWidth: 20)
                    .frame(width: 200, height: 200)
            }
            .padding()
            .rotationEffect(.degrees(-90))
            
            Text("Remaining Time: \(remainingTime) seconds")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(10)
                .padding()
        }
    }
}

struct ArcShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        return path
    }
}

struct RadialGaugeChart_Previews: PreviewProvider {
    static var previews: some View {
        RadialGaugeChart(remainingTime: 300, focusTime: 600)
    }
}
