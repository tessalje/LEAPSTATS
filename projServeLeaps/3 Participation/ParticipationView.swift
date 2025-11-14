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
        NavigationView {
            VStack {
                NavigationLink(destination: ParticipationHoursView()) {
                    ZStack {
                        HexagonFrontShape()
                            .foregroundStyle(Color(.lightBlue1))
                            .shadow(color: Color("lightGrey_2").opacity(1), radius: 4, x: 0, y: 10)
                        VStack {
                            Text("\(participation.attendance)% Attendance")
                                .foregroundColor(.black)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 40)
                            Text("Level \(participation.level)")
                                .foregroundColor(.black)
                        }
                        .frame(width: 200, height: 180)
                    }
                }
            }
        }
        .navigationTitle("Participation")
    }
}

#Preview {
    ParticipationView()
        .environmentObject(ParticipationData())
}
