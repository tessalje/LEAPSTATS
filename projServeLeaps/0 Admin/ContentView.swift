//
//  ContentView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 25/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var service: ServiceData
    @EnvironmentObject var leadership: LeadershipData
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var achievement: AchievementsData
    @EnvironmentObject var user: UserData
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("App Info", systemImage: "info.circle") {
                appInfoView()
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(LeadershipData())
        .environmentObject(ServiceData())
        .environmentObject(ParticipationData())
        .environmentObject(AchievementsData())
        .environmentObject(UserData())
}
