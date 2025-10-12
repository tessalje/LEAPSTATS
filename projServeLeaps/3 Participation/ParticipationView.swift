//
//  ParticipationView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI

struct ParticipationView: View {
    @EnvironmentObject var participation: ParticipationData
    
    var body: some View {
        ParticipationHourView()
    }
}

#Preview {
    ParticipationView()
        .environmentObject(ParticipationData())
}
