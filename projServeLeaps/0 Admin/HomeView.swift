//
//  HomeView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var service: ServiceData
    @EnvironmentObject var leadership: LeadershipData
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var achievement: AchievementsData
    @EnvironmentObject var user: UserData
    @State var AttainmentColor: Color = .red.opacity(0.5)
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationStack {
            VStack {
                // Top bar
                let spacingFactor: CGFloat = 1.23 // USE THIS TO CHANGE THE SPACING OF THE HEXAGONS
                let dx: CGFloat = 90 * spacingFactor
                let dyShort: CGFloat = 52 * spacingFactor
                let dyLong: CGFloat = 104 * spacingFactor
                
                ZStack {
                    // Center Hexagon
                    ZStack {
                        Hexagon()
                            .fill(AttainmentColor)
                            .frame(width: 140, height: 140)
                            .overlay(
                                Hexagon()
                                    .stroke(.black, lineWidth: 2)
                            )
                            .shadow(radius: 4)
                        
                        VStack(spacing: 4) {
                            Text("\(user.points) Points")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .bold()
                            Text("\(user.state)")
                            
                        }
                        .foregroundColor(.black)
                    }
                    
                    // Top
                    HexagonButton(title: "\(user.name)\n\(user.cca)", icon: nil, color: Color(red: 0.067, green: 0.243, blue: 0.353), textColor: .white) {
                        ProfileView()
                    }
                    .offset(x: 0, y: -dyLong)
                    
                    // Top-right
                    HexagonButton(title: "Leadership: \(leadership.currentLeadershipPosition)", icon: nil, color: Color(red: 0.012, green: 0.427, blue: 0.612), textColor: .white) {
                        LeadershipView()
                    }
                    .offset(x: dx, y: -dyShort)
                    
                    // Bottom-right
                    HexagonButton(title: "Achieved: \(achievement.name)", icon: nil, color: Color(red: 0.8, green: 0.941, blue: 1), textColor: .black) {
                        AchievementsView()
                    }
                    .offset(x: dx, y: dyShort)
                    
                    // Bottom
                    HexagonButton(title: "Service: \n\(service.total_hours) hours", icon: nil, color: Color(red: 0.8, green: 0.941, blue: 1), textColor: .black) {
                        ServiceView()
                    }
                    .offset(x: -dx, y: -dyShort)
                    
                    // Bottom-left
                    HexagonButton(title: "Attendance: \n\(participation.currentPercentage)%", icon: nil, color: Color(red: 0.012, green: 0.427, blue: 0.612), textColor: .white) {
                        ParticipationHourView()
                    }
                    .offset(x: -dx, y: dyShort)
                    
                    // Top-left
                    HexagonButton(
                        title: "LEAPS 2.0",
                        icon: "list.bullet.clipboard",
                        color: .white,
                        textColor: .black) {
                            InfoView()
                        }
                        .offset(x: 0, y: dyLong)
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: HelpView()) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .font(.title3)
                                Text("Help")
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            .navigationTitle("LEAPSTATS")
            .onAppear {
                leadership.loadLeadershipPositions()
            }
            .task {
                user.levelPointsData.calculatePoints(
                    leadership: leadership,
                    service: service,
                    participation: participation,
                    achievements: achievement
                )
                user.state = user.attainment(
                    leadership: leadership,
                    service: service,
                    participation: participation,
                    achievements: achievement
                )
                switch user.state {
                case "Excellent":
                    user.points = 2
                    AttainmentColor = Color.green.opacity(0.6)
                case "Good":
                    user.points = 1
                    AttainmentColor = Color.yellow.opacity(0.4)
                default:
                    user.points = 0
                    AttainmentColor = Color.red.opacity(0.5)
                }
            }
        }
    }
}
    
// DO NOT TOUCH
struct HexagonButton<Destination: View>: View {
    var title: String
    var icon: String? = nil
    var color: Color
    var textColor: Color = .white
    var destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            ZStack {
                Hexagon()
                    .fill(color)
                    .frame(width: 140, height: 140)
                    .shadow(radius: 4)
                
                VStack(spacing: 4) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.title2)
                    }
                    Text(title)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .padding(.horizontal, 20)
                        .font(.headline)
                        .bold()
                }
                .foregroundColor(textColor)
            }
            .frame(width: 100, height: 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
    
// DO NOT TOUCH
struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        
        for i in 0..<6 {
            let angle = Angle(degrees: Double(i) * 60)
            let x = center.x + CGFloat(cos(angle.radians)) * radius
            let y = center.y + CGFloat(sin(angle.radians)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}


#Preview {
    HomeView()
        .environmentObject(LeadershipData())
        .environmentObject(ServiceData())
        .environmentObject(ParticipationData())
        .environmentObject(AchievementsData())
        .environmentObject(UserData())
}
