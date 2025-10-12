//
//  Tutorial.swift
//  projServeLeaps
//
//  Created by Tessa on 22/7/25.
//

import SwiftUI

struct TutorialItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let color: Color
}

struct TutorialView: View {
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 170))]
    private var items: [TutorialItem] = [
        TutorialItem(title: "About", detail: "A LEAPS tracker to count your points", color: .teal),
        TutorialItem(title: "LEAPS", detail: "Check the Info page on LEAPS", color: .green),
        TutorialItem(title: "Hexagons", detail: "Press the hexagons to go to another page", color: .orange),
        TutorialItem(title: "Profile", detail: "Please choose your CCA and class in Profile", color: .pink),
        TutorialItem(title: "Feedback", detail: "Send us your feedback through our email", color: .purple),
        TutorialItem(title: "Privacy", detail: "Your LEAPS can be seen by teachers only", color: .blue)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Hi, how can we help you?")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 30) {
                        ForEach(items) { item in
                            TutorialCardView(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct TutorialCardView: View {
    let item: TutorialItem
    @State private var isClicked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: isClicked ? "chevron.up" : "chevron.down")
                    .foregroundColor(item.color)
            }
            .onTapGesture {
                withAnimation {
                    isClicked.toggle()
                }
            }
            if isClicked {
                Text(item.detail)
                    .font(.body)
                    .foregroundColor(.primary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .frame(width: 170, height: 150)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: item.color.opacity(0.4), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    TutorialView()
}
