//
//  participationInfo.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//
import SwiftUI
struct ParticipationInfoView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Participation is for students participation in CCA. It is based on the number of years of participation, their conduct and active contribution.")
                        .padding(10)
                        .frame(width: 380, height: 120)
                        .background(.darkerBlue1.opacity(0.5))
                        .cornerRadius(10)
                    
                    ForEach(participationLevels, id: \.self) { level in
                        LevelCard(level: level)
                    }
                }
                .padding()
            }
            .navigationTitle("Participation")
        }
    }
}

let participationLevels = [
    """
    Level 0:
    Did not participate in CCA enough
    """,
    """
    Level 1:
    Participated in any CCA for 2 years with at least 75% attendance each year.
    """,
    """
    Level 2: 
    Participated in any CCA for 3 years with at least 75% attendance each year.
    """,
    """
    Level 3: 
    Participated in any CCA for 4 years with at least 75% attendance each year.
    """,
    """
    Level 4:
    Participated in the same CCA for 4 years with exemplary conduct.
    """,
    """
    Level 5: 
    Participated in the same CCA for 5 years with exemplary conduct.
    """
]

#Preview {
    ParticipationInfoView()
}
