//
//  LeadershipPositionsView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 26/4/25.
//

//
//  LeadershipPositionsView.swift
//  projServe
//
//  Refactored with LeadershipDataManager class
//

import SwiftUI

struct LeadershipPositionView: View {
    @EnvironmentObject var dataManager: LeadershipData
    @State private var showSheet = false
    @State private var selectedPosition: String = ""
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var editingIndex: Int? = nil
    
    let yearRange = Array(Calendar.current.component(.year, from: Date())...3000)
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        VStack(spacing: -70) {
                            ForEach(dataManager.leadershipHexes.indices, id: \.self) { index in
                                let position = dataManager.leadershipHexes[index]
                                
                                HStack {
                                    if index % 2 == 0 {
                                        Spacer(minLength: 10)
                                    }
                                    
                                    LeadershipHexagonView(
                                        leadershipPositionName: position.name,
                                        leadershipPositionYear: position.year,
                                        level: position.level
                                    )
                                    .scaleEffect(editingIndex == index ? 1.1 : 1.0)
                                    .foregroundStyle(Int(position.level) ?? 0 < 3 ? Color("lightBlue_1") : Color("darkerBlue_1"))
                                    .compositingGroup()
                                    .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                                    .onTapGesture {
                                        selectedPosition = position.name
                                        selectedYear = position.year
                                        editingIndex = index
                                        showSheet = true
                                    }
                                    .contextMenu {
                                        Button("Remove", role: .destructive) {
                                            dataManager.removeLeadershipPosition(at: index)
                                        }
                                    }
                                    
                                    if index % 2 != 0 {
                                        Spacer(minLength: 10)
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                            
                            HStack {
                                if dataManager.leadershipHexes.count % 2 == 0 {
                                    Spacer(minLength: 30)
                                }
                                
                                addEventHexagon
                                    .padding(.top, -5)
                                    .frame(width: 150, height: 160)
                                
                                if dataManager.leadershipHexes.count % 2 != 0 {
                                    Spacer(minLength: 30)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
            .navigationTitle("Leadership")
            .padding()
            .sheet(isPresented: $showSheet) {
                LeadershipPositionSheet(
                    selectedPosition: $selectedPosition,
                    selectedYear: $selectedYear,
                    editingIndex: $editingIndex,
                    showSheet: $showSheet
                )
            }
        }
    }
    
    private var addEventHexagon: some View {
        ZStack {
            HexagonView()
                .foregroundStyle(Color("superLightGrey"))
                .compositingGroup()
                .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                .padding()
                .onTapGesture {
                    editingIndex = nil
                    selectedPosition = ""
                    selectedYear = Calendar.current.component(.year, from: Date())
                    showSheet = true
                }
            Text("+ New")
                .foregroundStyle(.black)
                .font(.system(size: 30))
        }
    }
}

struct LeadershipPositionSheet: View {
    @State private var searchText = ""
    @State private var showingSearchResults = false
    @EnvironmentObject var dataManager: LeadershipData
    @Binding var selectedPosition: String
    @Binding var selectedYear: Int
    @Binding var editingIndex: Int?
    @Binding var showSheet: Bool
    
    let yearRange = Array(Calendar.current.component(.year, from: Date())...3000)
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(LeadershipData.allCategories, id: \.self) { category in
                        DisclosureGroup(category) {
                            ForEach(LeadershipData.getPositionsForCategory(category), id: \.self) { item in
                                HStack {
                                    Text(item)
                                        .foregroundColor(.primary)
                                        .onTapGesture {
                                            selectedPosition = item
                                        }
                                    Spacer()
                                    if selectedPosition == item {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                } header: {
                    Text("Leadership Position")
                }
                
                Section {
                    Picker("Select a year", selection: $selectedYear) {
                        ForEach(yearRange, id: \.self) { year in
                            Text(String(year))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .tag(year)
                        }
                    }
                } header: {
                    Text("Year")
                }
                
                Section {
                    Button(editingIndex != nil ? "Update" : "Add") {
                        if !selectedPosition.isEmpty {
                            if let index = editingIndex {
                                dataManager.updateLeadershipPosition(at: index, name: selectedPosition, year: selectedYear)
                            } else {
                                dataManager.addLeadershipPosition(name: selectedPosition, year: selectedYear)
                            }
                            resetForm()
                        }
                    }
                    .disabled(selectedPosition.isEmpty)
                    
                    if editingIndex != nil {
                        Button("Delete") {
                            if let index = editingIndex {
                                dataManager.removeLeadershipPosition(at: index)
                                resetForm()
                            }
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button("Cancel") {
                        resetForm()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle(editingIndex != nil ? "Edit Position" : "Add Position")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func resetForm() {
        selectedPosition = ""
        selectedYear = Calendar.current.component(.year, from: Date())
        editingIndex = nil
        showSheet = false
    }
}

struct LeaderFrontPage: View {
    @EnvironmentObject var leadershipData: LeadershipData
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LeadershipPositionView()) {
                    ZStack {
                        HexagonFrontShape()
                            .foregroundStyle(Color(.lightBlue1))
                            .shadow(color: Color("lightGrey_2").opacity(1), radius: 4, x: 0, y: 10)
                            .padding()
                        VStack {
                            Text(leadershipData.currentLeadershipPosition)
                                .foregroundColor(.black)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 40)
                            Text("Level \(leadershipData.currentLevel)")
                                .foregroundColor(.black)
                        }
                    }
                    .frame(width: 200, height: 180)
                }
            }
        }
        .navigationTitle("Leadership")
    }
}




#Preview{
    LeaderFrontPage()
        .environmentObject(LeadershipData())
}

// Share Sheet remains the same
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
