//
//  Tutorial.swift
//  projServeLeaps
//
//  Created by Tessa on 22/7/25.
//
import SwiftUI

struct TutorialView: View {
    let images = ["image1", "image2", "image3", "image4", "image5"]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Color(red: 33/255, green: 33/255, blue: 33/255)
                .opacity(0.6)
                .ignoresSafeArea()
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()      // Make image fill screen
                        .ignoresSafeArea()   // Ignore safe area
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            

                        
                        
            if currentIndex == images.count - 1 {
                VStack {
                    Spacer()
                    Button(action: {
                        print("All done tapped!")
                        // Add your action here, e.g., dismiss the view
                    }) {
                        Text("You're All Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
}

#Preview {
    TutorialView()
}
