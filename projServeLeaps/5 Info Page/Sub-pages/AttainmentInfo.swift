//
//  attainmentView.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//

import SwiftUI

//make the levels start at 0 instad of 1

struct AttainmentView: View {
    @EnvironmentObject var service: ServiceData
    @EnvironmentObject var leadership: LeadershipData
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var achievement: AchievementsData
    @EnvironmentObject var user: UserData
    
    @State var attainment: String = "Fair: 0 Point"
    
    var p: Int { max(0, Int(participation.level) ?? 0) }
    var a: Int { max(0, Int(achievement.currentHighestLevel) ?? 0) }
    var l: Int { max(0, Int(leadership.currentLevel) ?? 0) }
    var s: Int { max(0, Int(service.level) ?? 0) }
    
    var levels: [Int] { [p, a, l, s] }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.lightblue.opacity(0.2).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(attainment)
                            .font(.title2)
                            .bold()
                            .foregroundColor(attainment == "Excellent: 2 Points" ? .green : (attainment == "Good: 1 Point" ? .orange : .red))
                        
                        Divider()
                            .frame(width: 380, height: 2)
                            .overlay(.gray)
                        
                        Group {
                            HStack {
                                Text("Participation:")
                                    .font(.headline)
                                LevelCard(level: participationLevels[p])
                            }
                            HStack {
                                Text("Achievement:")
                                    .font(.headline)
                                LevelCard(level: achievementLevels[a])
                            }
                            HStack {
                                Text("Leadership:")
                                    .font(.headline)
                                LevelCard(level: leadershipLevels[l])
                            }
                            HStack {
                                Text("Service:")
                                    .font(.headline)
                                LevelCard(level: serviceLevels[s])
                            }
                        }
                        .padding(5)
                        Divider()
                            .frame(width: 380, height: 2)
                            .overlay(.gray)
                        
                        Text("Each Attainment Level:")
                            .font(.headline)
                        
                        ForEach(AttainmentLevel, id: \.self) { level in
                            LevelCard(level: level)
                        }
                    }
                    .padding()
                    .onAppear {
                        let state = user.attainment(
                            leadership: leadership,
                            service: service,
                            participation: participation,
                            achievements: achievement
                        )
                        user.state = state
                        
                        switch state {
                        case "Excellent":
                            attainment = "Excellent: 2 Points"
                        case "Good":
                            attainment = "Good: 1 Point"
                        default:
                            attainment = "Fair: 0 Point"
                        }
                    }
                }
            }
            .navigationTitle("Level of Attainment")
        }
    }
}

let AttainmentLevel = [
    """
    1. Excellent:
    At least Level 3 in all domains, and Level 4 or higher in at least one domain.
    """,
    """
    2. Good: 
    At least Level 1 in all domains, and Level 2 or higher in at least three domains.
    """,
    """
    3. Fair: 
    Does not meet the above criteria.
    """
]


#Preview {
    AttainmentView()
        .environmentObject(LeadershipData())
        .environmentObject(ServiceData())
        .environmentObject(ParticipationData())
        .environmentObject(AchievementsData())
        .environmentObject(UserData())
}
