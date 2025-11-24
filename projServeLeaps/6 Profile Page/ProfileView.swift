//
//  ProfileView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import PhotosUI

extension Color {
    static let customRed = Color(red: 255/255, green: 89/255, blue: 94/255)
    static let customGreen = Color(red: 125/255, green: 200/255, blue: 140/255)
    static let customBlue = Color(red: 123/255, green: 197/255, blue: 243/255)
    static let customYellow = Color(red: 253/255, green: 226/255, blue: 108/255)
    static let customBlack = Color(red: 61/255, green: 61/255, blue: 61/255)
}

struct ProfileView: View {
    @EnvironmentObject var user: UserData
    @State private var showLogoutAlert = false
    @EnvironmentObject var userManager: UserManager

    let house = ["My House", "Red", "Yellow", "Green", "Blue", "Black"]
    let cca = ["My CCA", "ARC", "Astronomy", "Media", "Robotics", "SYFC", "Drama", "Guitar", "Show choir", "Dance", "Athletics", "Badminton", "Basketball", "Fencing", "Floorball", "Football", "Taekwondo", "Scouts"]
    
    @State private var isPresentedPopUp: Bool = false

    func BackColorHouse(for house: String) -> Color {
        switch house {
        case "My House": return .gray.opacity(0.5)
        case "Red": return .customRed
        case "Yellow": return .customYellow
        case "Green": return .customGreen
        case "Blue": return .customBlue
        case "Black": return .customBlack
        default: return Color(.lightGrey2)
        }
    }
    
    func BackColorCCA(for cca: String) -> Color {
        switch cca {
        case "My CCA": return .gray.opacity(0.5)
        default: return Color(.darkerBlue1.opacity(0.85))
        }
    }
    
    func textColor(for backgroundColor: Color) -> Color {
        if backgroundColor == Color("superLightGrey") {
            return .black
        }
        return .white
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Batch of \(user.year, format: .number.grouping(.never))")
                        .font(.title2)
                    
                    Spacer()
                    
                    ProfileHexagonView(title: user.house, color: BackColorHouse(for: user.house))
                    
                    Picker("house", selection: $user.house) {
                        ForEach(house, id: \.self) { houseName in
                            Text(houseName)
                        }
                    }
                    .tint(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(BackColorHouse(for: user.house))
                    )
                    .animation(.easeInOut, value: user.house)
                    
                    Spacer()
                    
                    ProfileHexagonView(title: user.cca, color: BackColorCCA(for: user.cca))
                    
                    Picker("cca", selection: $user.cca) {
                        ForEach(cca, id: \.self) { ccaName in
                            Text(ccaName)
                        }
                    }
                    .tint(.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(BackColorCCA(for: user.cca))
                    )
                    .animation(.easeInOut, value: user.cca)
                    .padding(.bottom, 20)
                    
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Text("Logout")
                            .bold()
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: 330, height: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Logout", role: .destructive) {
                            userManager.logout()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentedPopUp.toggle() }) {
                        Image(systemName: "square.and.pencil")
                    }
                    .foregroundColor(.black)
                    .sheet(isPresented: $isPresentedPopUp) {
                        EditView(userData: user)
                    }
                }
            }
            .navigationTitle("My Profile")
        }
    }
}

struct EditView: View {
    @ObservedObject var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss

    let currentYear = Calendar.current.component(.year, from: Date())

    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("My Name")
                    Spacer()
                    TextField("Name", text: $userData.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Year I joined SST")
                    Picker("My Sec 1 year", selection: $userData.year) {
                        ForEach(1900...(currentYear + 20), id: \.self) { year in
                            Text("\(year, format: .number.grouping(.never))")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 80)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Update")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.darkBlue1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Edit")
        }
        .presentationDetents([.height(400)])
    }
}


struct HexagonProfile: Shape {
    static let aspectRatio: CGFloat = 1

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = min(rect.width, rect.height * Self.aspectRatio)
        let size = width / 1.2
        let corners = (0..<6)
            .map {
                let angle = -CGFloat.pi / 3 * CGFloat($0)
                let dx = size * cos(angle)
                let dy = size * sin(angle)
                
                return CGPoint(x: center.x + dx, y: center.y + dy)
            }
        path.move(to: corners[0])
        corners[1..<6].forEach { point in
            path.addLine(to: point)
        }
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserData())
}
