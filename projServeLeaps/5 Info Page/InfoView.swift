//  InfoView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 26/4/25.
//

import SwiftUI

struct InfoView: View {
    @State private var searchText = ""
    @State private var showingSearchResults = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        TextField("Search", text: $searchText)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)
                                }
                            )
                            .padding(.horizontal, 10)
                            .onSubmit {
                                if !searchText.isEmpty {
                                    showingSearchResults = true
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button("Cancel") {
                                searchText = ""
                                showingSearchResults = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .padding(.trailing, 10)
                            .transition(.move(edge: .trailing))
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    if showingSearchResults && !searchText.isEmpty {
                        SearchResultsView(searchText: searchText)
                    } else {
                        VStack {
                            HStack {
                                NavigationLink(destination: LeadershipInfoView()) {
                                    VStack {
                                        Text("Leadership")
                                        Image(systemName: "medal.star")
                                    }
                                    .font(.title3)
                                    .frame(width: 160, height: 160)
                                    .background(.darkBlue1)
                                    .cornerRadius(10)
                                    .foregroundStyle(.white)
                                }
                                
                                NavigationLink(destination: AchievementInfoView()) {
                                    VStack {
                                        Text("Achievement")
                                        Image(systemName: "trophy")
                                    }
                                    .font(.title3)
                                    .frame(width: 160, height: 160)
                                    .background(Color(red: 0.8, green: 0.941, blue: 1))
                                    .cornerRadius(10)
                                    .foregroundStyle(.black)
                                }
                            }
                            
                            HStack {
                                NavigationLink(destination: ParticipationInfoView()) {
                                    VStack {
                                        Text("Participation")
                                        Image(systemName: "person.3.fill")
                                    }
                                    .font(.title3)
                                    .frame(width: 160, height: 160)
                                    .background(.darkerBlue1)
                                    .cornerRadius(10)
                                    .foregroundStyle(.white)
                                }
                                
                                NavigationLink(destination: ServiceInfoView()) {
                                    VStack {
                                        Text("Service")
                                        Image(systemName: "figure.roll")
                                    }
                                    .font(.title3)
                                    .frame(width: 160, height: 160)
                                    .background(Color(red: 0.012, green: 0.427, blue: 0.612))
                                    .cornerRadius(10)
                                    .foregroundStyle(.white)
                                }
                            }
                            .padding(5)
                            
                            NavigationLink(destination: AttainmentView()) {
                                HStack {
                                    Text("Level of Attainment")
                                    Image(systemName: "graduationcap")
                                }
                                .font(.title3)
                                .frame(width: 330, height: 120)
                                .background(.lightGrey2)
                                .cornerRadius(10)
                                .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("LEAPS info")
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    showingSearchResults = false
                }
            }
        }
    }
}

struct SearchResultsView: View {
    let searchText: String
    
    var searchResults: [SearchResult] {
        var results: [SearchResult] = []

        for (index, level) in leadershipLevels.enumerated() {
            if level.localizedCaseInsensitiveContains(searchText) {
                results.append(SearchResult(
                    category: "Leadership",
                    levelIndex: index,
                    content: level,
                    destination: AnyView(LeadershipInfoView())
                ))
            }
        }

        for (index, level) in achievementLevels.enumerated() {
            if level.localizedCaseInsensitiveContains(searchText) {
                results.append(SearchResult(
                    category: "Achievement",
                    levelIndex: index,
                    content: level,
                    destination: AnyView(AchievementInfoView())
                ))
            }
        }

        for (index, level) in participationLevels.enumerated() {
            if level.localizedCaseInsensitiveContains(searchText) {
                results.append(SearchResult(
                    category: "Participation",
                    levelIndex: index,
                    content: level,
                    destination: AnyView(ParticipationInfoView())
                ))
            }
        }

        for (index, level) in serviceLevels.enumerated() {
            if level.localizedCaseInsensitiveContains(searchText) {
                results.append(SearchResult(
                    category: "Service",
                    levelIndex: index,
                    content: level,
                    destination: AnyView(ServiceInfoView())
                ))
            }
        }

        for (index, level) in AttainmentLevel.enumerated() {
            if level.localizedCaseInsensitiveContains(searchText) {
                results.append(SearchResult(
                    category: "Level of Attainment",
                    levelIndex: index,
                    content: level,
                    destination: AnyView(AttainmentView())
                ))
            }
        }
        return results
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Search Results for '\(searchText)'")
                    .font(.headline)
                    .padding(.horizontal)
                
                if searchResults.isEmpty {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No results found")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Try searching for different terms like 'CCA', 'leadership', 'service hours', etc.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(searchResults.indices, id: \.self) { index in
                            let result = searchResults[index]
                            
                            NavigationLink(destination: result.destination) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(result.category)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(highlightedText(result.content, searchTerm: searchText))
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(5)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func highlightedText(_ text: String, searchTerm: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if let range = attributedString.range(of: searchTerm, options: .caseInsensitive) {
            attributedString[range].backgroundColor = .yellow.opacity(0.3)
            attributedString[range].foregroundColor = .primary
        }
        
        return attributedString
    }
}

struct SearchResult {
    let category: String
    let levelIndex: Int
    let content: String
    let destination: AnyView
}

#Preview {
    InfoView()
        .environmentObject(LeadershipData())
        .environmentObject(ServiceData())
        .environmentObject(ParticipationData())
        .environmentObject(AchievementsData())
        .environmentObject(UserData())
}
