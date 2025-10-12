//
//  HexagonView2.swift
//  projServe
//
//  Created by Tessa on 26/5/25.
//

import SwiftUI


struct HexagonFrontShape: View {
    var body: some View {
        ZStack {
            HexagonShape()
                .frame(width: 180, height: 200) // Adjust size as needed
                .rotationEffect(.degrees(90)) // Rotate hexagon
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
}
