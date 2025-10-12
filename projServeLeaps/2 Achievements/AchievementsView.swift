////
////  AchievementsView.swift
////  projServe
////
////  Created by Vijayaganapathy Pavithraa on 26/4/25.
////

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var acheivements: AchievementsData

    var body: some View {
        AchievementsFrontPage()
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AchievementsData())
}
