//
//  ParticpationAttendanceView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI

struct ParticipationHoursView: View {
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    
    @State private var showingDataSource = false
    
    var body: some View {
            VStack {
                ZStack{
                    Hexagon()
                        .fill(Color(participation.attendance > 75 ? .green : .red))
                        .frame(width: 180, height: 180)
                        .shadow(radius: 4)
                    
                    VStack(spacing: 4) {
                        Text("\(participation.attendance)%")
                            .multilineTextAlignment(.center)
                            .lineLimit(4)
                            .padding(.horizontal, 20)
                            .bold()
                            .font(.system(size: 35, weight: .bold))
                        Text(participation.studentName)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Link("Attendance sheet", destination: URL(string: "https://docs.google.com/spreadsheets/d/1R7JwhmOwkEVUNPzPTGzedaiZALz62xAHmDt3JsHDR0M/edit?gid=0#gid=0")!)
                    }
                }
                if participation.googleSheetsService.isLoading {
                    ProgressView("Fetching latest data...")
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 15) {
                        HStack {
                                Text("Sessions Missed")
                                    .foregroundColor(.secondary)
                            Spacer()
                            Text("\(participation.missedSessions)") //fix this
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Participation")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        participation.fetchGoogleSheetsData(studentName: participation.studentName)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                participation.refreshData()
            }
            
            // Error message
            if let errorMessage = participation.googleSheetsService.errorMessage {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Error")
                            .fontWeight(.semibold)
                    }
                    Text(errorMessage)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
    }
}
    
#Preview {
    ParticipationHoursView()
        .environmentObject(UserData())
        .environmentObject(ParticipationData())
}
