//
//  LeadershipView.swift
//  projServe
//
//  Created by Tessa on 27/5/25.
//

import SwiftUI

// Updated main LeadershipView
struct LeadershipView: View {
    @EnvironmentObject var leadershipData: LeadershipData
    var body: some View {
        LeaderFrontPage().onAppear {
            leadershipData.loadLeadershipPositions()
        }
    }
}

#Preview {
    LeadershipView()
        .environmentObject(LeadershipData())
}

