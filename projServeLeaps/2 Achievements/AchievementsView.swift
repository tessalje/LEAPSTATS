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
        NavigationView {
            VStack {
                NavigationLink(destination: AchievementsAwardsView()) {
                    ZStack {
                        HexagonFrontShape()
                            .foregroundStyle(Color(.lightBlue1))
                            .shadow(color: Color("lightGrey_2").opacity(1), radius: 4, x: 0, y: 10)
                        VStack {
                            Text("\(acheivements.achievementCount) awards")
                                .foregroundColor(.black)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 40)
                            Text("Level \(acheivements.currentHighestLevel)")
                                .foregroundColor(.black)
                        }
                        .frame(width: 200, height: 180)
                    }
                }
            }
        }
        .navigationTitle("Achievements")
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AchievementsData())
}
