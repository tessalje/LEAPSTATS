//
//  HexagonView.swift
//  SSTLeaps_Teachers
//
//  Created by Kesler Ang Kang Zhi on 1/7/25.
//


import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let points: [CGPoint] = [
            CGPoint(x: width * 0.50, y: 0), // Top
            CGPoint(x: width, y: height * 0.25), // Top-right
            CGPoint(x: width, y: height * 0.75), // Bottom-right
            CGPoint(x: width * 0.50, y: height), // Bottom
            CGPoint(x: 0, y: height * 0.75), // Bottom-left
            CGPoint(x: 0, y: height * 0.25), // Top-left
        ]

        var path = Path()
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

struct HexagonView: View {
    var text: String
    let color: Color
    let font: Font
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(color)
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .shadow(radius: 3)
            Text(text)
                .font(font)
                .multilineTextAlignment(.center)
                .padding(16) // Padding to avoid edges
                .frame(width: 110, height: 100, alignment: .center) // Inner frame for text
                .minimumScaleFactor(0.4) // Shrink text if absolutely needed
                .lineLimit(nil) // No limit on number of lines
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 160)
    }
}
