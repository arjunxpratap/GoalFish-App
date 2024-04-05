import SwiftUI

struct Wave: Shape {
    let offset: Double
    let percent: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        path.move(to: CGPoint(x: 0, y: height * (1 - percent)))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height * (1 - percent)))
        
        for angle in stride(from: 0, to: 360, by: 5) {
            let radians = Double(angle) * .pi / 180
            let sine = sin(radians + offset)
            let waveHeight = 10 * sine
            let x = width * (Double(angle) / 360)
            let y = height * (1 - percent) + waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}
