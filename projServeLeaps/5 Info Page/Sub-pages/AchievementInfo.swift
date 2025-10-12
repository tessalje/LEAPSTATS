//
//  achievementInfo.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//
import SwiftUI
struct AchievementInfoView: View {
    var body: some View {
        ZStack {
            Color(red: 0.8, green: 0.941, blue: 1).opacity(0.6).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    Text("What is Achivement?")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Achievement levels are for students accomplishments in CCA outside classrooms. Opportunities to representant schools are important experiences and better caters to their interests and talents.")
                        .padding(10)
                        .frame(width: 380, height: 130)
                        .background(.white.opacity(0.6))
                        .cornerRadius(10)
                    
                    ForEach(achievementLevels, id: \.self) { level in
                        LevelCard(level: level)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievement")
        }
    }
}

let achievementLevels = [
    """
    Level 0: 
    - Not enough achievements
    """,
    """
    Level 1: 
    - Represented class or CCA at intraschool event.
    """,
    """
    Level 2: 
    - Represented school at a local event for 1 year.
    """,
    """
    Level 3:
    - Represented school/external at local/international event for 1 year and received:
      1. Top 4 team placing
      2. Top 8 individual
    - Represented school/external at local/international event for 2 years
    """,
    """
    Level 4: 
    - Represented school/external at local/international event for 3-4 years 
    - Represented UG HQ at international event
    - Represented school/external at local/international event for 2 years and recieved: 
      1. Top 4 team placing
      2. Top 8 individual
    """,
    """
    Level 5:
    - Represented school at local/international competition
    - Represented Singapore at international event, approved by Singapore organisation
    - Represented National Project of Excellence at local/international event
    - Represented MOE at local/international event
    - Represented UG HQ at international competition AND
    - Represented Singapore Schools/National Project of Excellence/MOE at local/international event
    - Represented Singapore at international event, approved by Singapore organisation
    - SYF Arts Presentation
    """
]


#Preview {
    AchievementInfoView()
}
