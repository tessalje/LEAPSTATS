//
//  LevelCardView.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//

import SwiftUI
struct LevelCard: View {
    let level: String
    @State private var isClicked = false
    
    var body: some View {
        
        let lines = level.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        let title = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = lines.count > 1 ? lines[1].trimmingCharacters(in: .whitespacesAndNewlines) : ""
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: isClicked ? "chevron.up" : "chevron.down")
                    .foregroundColor(.blue)
            }
            .onTapGesture {
                withAnimation {
                    isClicked.toggle()
                }
            }
            if isClicked {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .frame(maxWidth: 350, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 6, x:5, y:8)
    }
}

#Preview {
    LevelCard(level: "hi")
}
