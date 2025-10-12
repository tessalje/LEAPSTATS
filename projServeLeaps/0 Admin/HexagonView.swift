//
//  HexagonView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 26/4/25.
//
import SwiftUI

struct HexagonView: View {
    var body: some View {
        ZStack {
            HexagonShape()
                .frame(width: 150, height: 160) // Adjust size as needed
                .rotationEffect(.degrees(90)) // Rotate hexagon
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
}

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



struct AchivementHexagonView: View {
    var name: String
    var detail: String
    var textColor: Color
    
    var body: some View {
        ZStack {
            HexagonShape()
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Text(name)
                            .foregroundColor(textColor)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(10)
                        Text(detail)
                            .foregroundColor(textColor)
                    }
                )
        }
    }
}



struct EventHexagonView: View {
    var eventName: String
    var eventHours: Int

    var textColor: Color {
        eventHours < 3 ? .black : .white
    }

    var backgroundColor: Color {
        eventHours < 3 ? Color("lightBlue_1") : Color("darkerBlue_1")
    }

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(backgroundColor)
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Text(eventName)
                            .foregroundColor(textColor)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .lineLimit(nil)

                        Text("\(eventHours) Hour\(eventHours == 1 ? "" : "s")")
                            .foregroundColor(textColor)
                            .multilineTextAlignment(.center)
                    }
                )
        }
    }
}



struct EnrichmentHexagonView: View {
    var enrichmentName: String
    var enrichmentDate: Date
    var color: Color = Color("lightBlue_1")

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(color)
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Text("\(enrichmentName)")
                            .foregroundColor(.black)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .lineLimit(nil)

                        Text(enrichmentDate.formatted(.dateTime.day().month().year()))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                )
        }
    }
}



struct LeadershipHexagonView: View {
    var leadershipPositionName: String
    var leadershipPositionYear: Int
    var level: String
    
    var textColor: Color {
        leadershipPositionYear < 3 ? .black : .white
    }
    
    var backgroundColor: Color {
        leadershipPositionYear < 3 ? Color("lightBlue_1") : Color("darkerBlue_1")
    }
    
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(backgroundColor)
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Text(leadershipPositionName)
                            .foregroundColor(textColor)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .lineLimit(nil)
                        
                        Text("\(leadershipPositionYear)")
                            .foregroundColor(textColor)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        
                        Text("Level \(level)")
                            .foregroundColor(textColor)
                            .font(.caption)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                )
        }
    }
}



struct ProfileHexagonView: View {
    let title: String
    let color: Color
    var body: some View {
        ZStack {
            HexagonProfile()
                .fill(color)
                .frame(width: 100, height: 130)
                .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
            VStack {
                Text(title)
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontDesign(.rounded)
            }
        }
        .padding()
    }
}




