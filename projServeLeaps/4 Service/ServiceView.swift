//
//  ServiceView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 26/4/25.
//

import SwiftUI

struct ServiceView: View {
    @EnvironmentObject var service: ServiceData
    @State var showSheet2 = false
    let step = 1
    let range = 0...100
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ServiceHoursView()) {
                    ZStack {
                        HexagonFrontShape()
                            .foregroundStyle(Color(.lightBlue1))
                            .shadow(color: Color("lightGrey_2").opacity(1), radius: 4, x: 0, y: 10)
                            .padding()
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.horizontal, 40)
                        VStack {
                            Text("\(service.total_hours) hours")
                                .foregroundColor(.black)
                                .font(.title2)
                            Text("Level \(service.level)")
                                .foregroundColor(.black)
                        }
                    }
                    .frame(width: 200, height: 180)
                }
            }
        }
        .navigationTitle("Service")
    }
}

#Preview {
    ServiceView()
        .environmentObject(ServiceData())
}
