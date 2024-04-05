//
//  BarChart.swift
//  GoalFish
//
//  Created by user2 on 05/03/24.
//
import SwiftUI
import Charts
struct BarChart: View {
    let label: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
                .padding(.bottom, 5)
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 20)
                .foregroundColor(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: calculateWidth(), height: 20)
                        .foregroundColor(.green)
                )
        }
    }
    
    private func calculateWidth() -> CGFloat {
        let totalWidth: CGFloat = 200 // Total width of the bar
        let maxValue: CGFloat = 120 // Maximum possible value (in this case, it represents the total focus time or remaining time)
        let ratio = CGFloat(value) / maxValue
        return totalWidth * ratio
    }
}
