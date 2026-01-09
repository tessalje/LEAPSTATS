//
//  NyaaView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//
import SwiftUI

struct HelpView: View {
    let images = ["image1", "image2", "image3", "image4", "image5"]
    @State private var currentIndex = 0
    @Environment(\.dismiss) var dismiss 
    
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
                    Text("You're All Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    Spacer()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: currentIndex)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Exit") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    HelpView()
}
