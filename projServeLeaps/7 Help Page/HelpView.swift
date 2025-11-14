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
    
    var body: some View {
        NavigationStack {
            Text("GO TO TUTROIAL !!")
        }
    }
}

#Preview {
    HelpView()
}
