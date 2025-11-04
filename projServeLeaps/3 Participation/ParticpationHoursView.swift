//
//  ParticpationAttendanceView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

//
import SwiftUI

struct ParticipationHourView: View {
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    
    @State private var startingRow = 2
    @State private var numberOfRows = 100
    
    var body: some View {
        NavigationView {
            VStack {
                
                if participation.googleSheetsService.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if participation.googleSheetsService.cellPairs.isEmpty && participation.googleSheetsService.errorMessage == nil {
                    VStack(spacing: 20) {
                        Text("No data found for '\(user.name)'")
                            .foregroundColor(.gray)
                        
                        // Show default Firebase data if available
                        if participation.attendance > 0 {
                            Text("Showing Firebase data:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ParticipationHexagon2Advanced(participationData: participation)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(participation.googleSheetsService.cellPairs) { pair in
                                VStack(alignment: .leading) {
                                    
                                    // Update ParticipationData with Google Sheets data
                                    let percentageInt = Int(pair.rightValue) ?? 0
                                    
                                    ParticipationHexagon2Advanced(participationData: participation)
                                        .onAppear {
                                            // Update the participation data when this cell appears
                                            participation.sheetsPercentage = percentageInt
                                        }
                                    
                                    // Optional: Show additional info about the data source
                                    HStack {
                                        Text("Row \(pair.rowNumber)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("Google Sheets Data")
                                            .font(.caption2)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal)
                                    
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Error message
                if let errorMessage = participation.googleSheetsService.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding()
                }
                
                // Data source indicator
                HStack {
                    Image(systemName: participation.sheetsPercentage > 0 ? "doc.text" : "icloud")
                    Text(participation.sheetsPercentage > 0 ? "Google Sheets" : "Firebase")
                    Text("• \(participation.currentPercentage)%")
                        .fontWeight(.medium)
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            }
            .navigationTitle("Participation")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        participation.fetchParticipation()
                    } label: {
                        Image(systemName: "icloud.and.arrow.down")
                    }
                    
                    Button {
                        participation.fetchGoogleSheetsData(studentName: user.name)
                    } label: {
                        Image(systemName: "arrow.trianglehead.clockwise")
                    }
                }
            }
            .onAppear {
                participation.fetchParticipation()
                participation.fetchGoogleSheetsData(studentName: user.name)
            }
        }
    }
}


struct ParticipationHourViewDetailed: View {
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    
    @State private var showingDataSource = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                //Main Hexagon Display
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.05))
                        .shadow(radius: 2)
                    
                    VStack(spacing: 15) {
                        if participation.googleSheetsService.isLoading {
                            ProgressView("Fetching latest data...")
                        } else {
                            ParticipationHexagon2Advanced(participationData: participation)
                        }
                        
                        //Data source toggle
                        Button(action: {
                            showingDataSource.toggle()
                        }) {
                            HStack {
                                Image(systemName: participation.sheetsPercentage > 0 ? "doc.text" : "icloud")
                                Text(participation.sheetsPercentage > 0 ? "Google Sheets Data" : "Firebase Data")
                                Image(systemName: "info.circle")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                // Data source details (expandable)
                if showingDataSource {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data Sources:")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "icloud")
                            Text("Firebase: \(participation.attendance)%")
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Google Sheets: \(participation.sheetsPercentage)%")
                            Spacer()
                        }
                        
                        if participation.googleSheetsService.cellPairs.count > 1 {
                            Text("Found \(participation.googleSheetsService.cellPairs.count) matching records")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                //extra Google Sheets records
                if participation.googleSheetsService.cellPairs.count > 1 {
                    Text("Additional Records:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(Array(participation.googleSheetsService.cellPairs.enumerated()), id: \.element.id) { index, pair in
                                if index > 0 { // Skip first one as its shown in main display
                                    HStack {
                                        Text("Row \(pair.rowNumber)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text("\(pair.rightValue)%")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Error message
                if let errorMessage = participation.googleSheetsService.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Participation")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        participation.fetchParticipation()
                    } label: {
                        Image(systemName: "icloud.and.arrow.down")
                    }
                    
                    Button {
                        participation.fetchGoogleSheetsData(studentName: user.name)
                    } label: {
                        Image(systemName: "arrow.trianglehead.clockwise")
                    }
                }
            }
            .onAppear {
                participation.fetchParticipation()
                participation.fetchGoogleSheetsData(studentName: user.name)
            }
        }
    }
}

#Preview {
    ParticipationHourView()
        .environmentObject(UserData())
        .environmentObject(ParticipationData())
}
