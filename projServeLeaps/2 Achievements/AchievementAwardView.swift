//
//  AchievementAward.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI

struct AchievementsFrontPage: View {
    @EnvironmentObject var achievementsData: AchievementsData
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AchievementsAwardsView()) {
                    ZStack {
                        HexagonFrontShape()
                            .foregroundStyle(Color(.lightBlue1))
                            .shadow(color: Color("lightGrey_2").opacity(1), radius: 4, x: 0, y: 10)
                        VStack {
                            Text("\(achievementsData.name)")
                                .foregroundColor(.black)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 40)
                            Text("Level \(achievementsData.currentHighestLevel)")
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


struct AchievementsAwardsView: View {
    @EnvironmentObject var achievementsData: AchievementsData
    @State private var showSheet = false
    @State private var editingIndex: Int? = nil
    @State private var award_name: String = ""
    
    var type = [
        "Competition",
        "Event",
        "SYF"
    ]
    var representation_level = [
        "Intra-school",
        "School/External Organisation",
        "National (SG/MOE/UG HQ)"
    ]
    
    var years = [
        "1 year",
        "2 years",
        "3 or more years"
    ]
    
    var awards = [
        "Participation (No award)",
        "Top 4 team placing",
        "Top 8 individual placing",
        "Gold/Silver/Bronze/Merit certificate"
    ]
    
    @State private var selectedType = "Competition"
    @State private var selectedRepresent = "Intra-school"
    @State private var selectedYears = "1 year"
    @State private var selectedAwards = "Participation (No award)"
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ZStack {
                        VStack(spacing: -70) {
                            ForEach(Array(achievementsData.hexes.enumerated()), id: \.element.id) { index, achievement in
                                HStack {
                                    if index % 2 == 0 {
                                        Spacer(minLength: 30)
                                    }
                                    
                                    AchivementHexagonView(name: achievement.name, detail: "Level \(achievement.level)", textColor: textColor(achievement.level))
                                        .scaleEffect(editingIndex == index ? 1.1 : 1.0)
                                        .foregroundStyle(getColorForLevel(achievement.level))
                                        .compositingGroup()
                                        .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                                        .onTapGesture {
                                            award_name = achievement.name
                                            selectedRepresent = achievement.representation
                                            selectedAwards = achievement.award
                                            selectedYears = achievement.year
                                            editingIndex = index
                                            showSheet = true
                                        }
                                         
                                    if index % 2 != 0 {
                                        Spacer(minLength: 10)
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                            
                            HStack {
                                if achievementsData.hexes.count % 2 == 0 {
                                    Spacer(minLength: 30)
                                }
                                
                                addEventHexagon
                                    .padding(.top, -5)
                                    .frame(width: 150, height: 160)
                                
                                if achievementsData.hexes.count % 2 != 0 {
                                    Spacer(minLength: 30)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
            .navigationTitle("Achievements")
            .padding()
            .sheet(isPresented: $showSheet) {
                Form {
                    Section {
                        TextField("Name:", text: $award_name)
                            .keyboardType(.default)
                        Picker("Type:", selection: $selectedType) {
                            ForEach(type, id: \.self) {
                                Text($0)
                            }
                        }
                    } header: {
                        Text("Event/Competition")
                    }
                    Section {
                        Picker("Representation:", selection: $selectedRepresent) {
                            ForEach(representation_level, id: \.self) {
                                Text($0)
                            }
                        }
                    } header: {
                        Text("Representation Level")
                    }
                    
                    Section {
                        Picker("No. of years:", selection: $selectedYears) {
                            ForEach(years, id: \.self) {
                                Text($0)
                            }
                        }
                    } header: {
                        Text("Years")
                    }
                    
                    Section {
                        Picker("Achievement:", selection: $selectedAwards) {
                            ForEach(awards, id: \.self) {
                                Text($0)
                            }
                        }
                    } header: {
                        Text("Achievement/Award")
                    }
                    
                    Button(editingIndex != nil ? "Update" : "Add") {
                        if !award_name.isEmpty {
                            if let index = editingIndex {
                                achievementsData.updateAchievement(
                                    at: index,
                                    name: award_name,
                                    award: selectedAwards,
                                    representation: selectedRepresent,
                                    year: selectedYears
                                ) { success in
                                    if success { resetForm() }
                                }
                            } else {
                                achievementsData.addAchievement(
                                    name: award_name,
                                    award: selectedAwards,
                                    representation: selectedRepresent,
                                    year: selectedYears
                                ) { success in
                                    if success { resetForm() }
                                }
                            }
                        }
                    }
                    if editingIndex != nil {
                        Button("Delete") {
                            if let index = editingIndex {
                                achievementsData.removeAchievement(at: index)
                                resetForm()
                                
                            }
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button("Cancel") {
                        resetForm()
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
    
    private func resetForm() {
        editingIndex = nil
        award_name = ""
        selectedType = "Competition"
        selectedRepresent = "Intra-school"
        selectedYears = "1 year"
        selectedAwards = "Participation (No award)"
        showSheet = false
    }
    
    private func getColorForLevel(_ level: String) -> Color {
        switch level {
        case "1": return Color("lightBlue_1")
        case "2": return Color("lightBlue_1")
        case "3": return Color("darkerBlue_1")
        case "4": return Color("darkerBlue_1")
        case "5": return Color("darkerBlue_1")
        default: return Color("lightBlue_1")
        }
    }
    
    private func textColor(_ level: String) -> Color {
        switch level {
        case "1": return Color(.black)
        case "2": return Color(.black)
        case "3": return Color(.white)
        case "4": return Color(.white)
        case "5": return Color(.white)
        default: return Color(.black)
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
                    resetForm()
                    showSheet = true
                }
            Text("+ New")
                .foregroundStyle(.black)
                .font(.system(size: 30))
        }
    }
}

#Preview {
    AchievementsFrontPage()
        .environmentObject(AchievementsData())
}

