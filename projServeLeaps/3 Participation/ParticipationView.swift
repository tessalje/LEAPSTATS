//
//  ParticipationView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI

struct ParticipationView: View {
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    
    var body: some View {
        ParticipationHourView()
            .environmentObject(participation)
            .environmentObject(user)
    }
}

#Preview {
    ParticipationView()
        .environmentObject(ParticipationData())
        .environmentObject(UserData())
}
