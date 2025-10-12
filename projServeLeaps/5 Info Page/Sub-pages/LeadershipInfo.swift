//
//  leadershipInfo.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//
import SwiftUI
struct LeadershipInfoView: View {
    var body: some View {
        ZStack {
            Color.darkBlue1.opacity(0.5).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    Text("What is Leadership?")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Leadership levels are for students who develop leadership skills (e.g. take charge of their growth, work in teams, and serve others). This includes boards, CCA, lead in a project, NYAA.")
                        .padding(10)
                        .frame(width: 380, height: 120)
                        .background(.white.opacity(0.6))
                        .cornerRadius(10)
                    
                    ForEach(leadershipLevels, id: \.self) { level in
                        LevelCard(level: level)
                    }
                }
                .padding()
            }
            .navigationTitle("Leadership")
        }
    }
}

let leadershipLevels = [
    """
    Level 0: 
    - No roles
    """,
    """
    Level 1:
    - Completed 2 leadership modules (at least 3h each)
    """,
    """
    Level 2:
    - Class Committee
    - Committee for student-initiate/student-led projects, approved by school
    - NYAA Bronze
    """,
    """
    Level 3:
    - Class Chairperson
    - Lower Sec Student Council
    - Lower Sec Peer Support Leader
    - Lower Sec ACE Leader
    - Lower Sec House Leader
    - Lower Sec DC leader
    - Lower Sec CCA Exco Committee
    - Exco for school-wide events
    - Chairperson/Vice-Chairperson for student-initiated/student-led projects, approved by school
    - NYAA Silver/Gold
    """,
    """
    Level 4:
    - Upper Sec Student Council
    - Upper Sec Peer Support Leader
    - Upper Sec ACE Leader
    - Upper Sec House Exco
    - Upper Sec House Captain
    - Upper Sec House Vice-Captain
    - Upper Sec DC leader
    - Chairperson/ViceChair person for school-wide events
    - Upper Sec CCA Exco Committee
    """,
    """
    Level 5:
    - Student Council Exco
    - Peer Support Leader Exco
    - ACE Leader Exco
    - House Leader Exco
    - DC leader Exco
    - CCA Chairperson/Vice-Chairperson
    """
]

#Preview {
    LeadershipInfoView()
}
