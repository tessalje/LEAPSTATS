//
//  LoginView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

// USERMANAGER CLASS
class UserManager: ObservableObject {
    static let shared = UserManager()

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    @Published var currentUserID: String? = nil
    @Published var currentUserEmail: String? = nil
    @Published var currentUserName: String? = nil
    @Published var isLoggedIn: Bool = false

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    self.currentUserID = user.uid
                    self.currentUserEmail = user.email
                    self.fetchUserName(uid: user.uid)
                    self.isLoggedIn = true  // <-- set here
                    completion(.success(()))
                }
            }
        }
    }

    func logout() {
        do {
            try auth.signOut()
            isLoggedIn = false  // <-- set here to return to LoginView
            currentUserID = nil
            currentUserEmail = nil
            currentUserName = nil
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                self.currentUserID = user.uid
                self.currentUserEmail = user.email
                self.currentUserName = name

                // SAVES DATA FOR SIGN UP
                self.db.collection("users").document(user.uid).setData([
                    "name": name,
                    "email": email
                ]) { err in
                    if let err = err {
                        completion(.failure(err))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
        
    }
    
    // GETS THE NAME
    private func fetchUserName(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(), let name = data["name"] as? String {
                self.currentUserName = name
            }
        }
    }
}


// LOGIN VIEW
struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var service: ServiceData
    @EnvironmentObject var leadership: LeadershipData
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var achievement: AchievementsData
    @EnvironmentObject var user: UserData

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var loginError: String? = nil
    @State private var isLoggedIn: Bool = false
    

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // App Icon CHANGE TO THE ACTUAL LOGO
                Image(systemName: "figure.stairs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.top, 50)
                    .foregroundStyle(MeshGradient(width: 2, height: 2, points:
                                                    [[0, 0], [1, 0],
                                                     [0, 1], [1, 1]],
                                                  colors: [
                                                    .lightblue, .blue,
                                                    .blue, .darkerBlue1]))

                // TITLE AND STUFF
                VStack(spacing: 4) {
                    Text("LEAPSTATS")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.primary)

                    Text("Leap to success")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .fontDesign(.monospaced)
                }
                
                //TEXTFIELDS FOR EMAIL AND PASSWORD
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(.lightGrey2)
                    .cornerRadius(12)
                
                // BASICALLY IT WILL BE THE DOTS THING UNLESSS ITS TOGGLED TO SHOW
                ZStack {
                    if isSecure {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(.lightGrey2)
                            .cornerRadius(12)
                    } else {
                        TextField("Password", text: $password)
                            .padding()
                            .background(.lightGrey2)
                            .cornerRadius(12)
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Text(isSecure ? "Show" : "Hide")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .padding(.trailing, 16)
                        }
                    }
                }

                
                Button("Login") {
                    guard !email.isEmpty, !password.isEmpty else {
                        loginError = "Email and password must not be empty."
                        return
                    }

                    userManager.signIn(email: email, password: password) { result in
                        switch result {
                        case .success:
                            loginError = nil
                        case .failure(let error):
                            loginError = "Login failed: Email or password is incorrect"
                        }
                    }
                }
                .frame(width: 340, height: 55)
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: .init(colors: [Color.blue, Color.lightblue]),
                        startPoint: .init(x: 0.9, y: 0.66),
                        endPoint: .init(x: 0, y: -0.33)
                    ))
                .clipShape(RoundedRectangle(cornerRadius: 15))

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Navigation to Sign Up (unchanged)
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)

                Spacer()
            }
            .padding(.horizontal, 32)
            .background(.background)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .preferredColorScheme(.light)
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(LeadershipData())
        .environmentObject(ServiceData())
        .environmentObject(ParticipationData())
        .environmentObject(AchievementsData())
        .environmentObject(UserData())
        .environmentObject(UserManager.shared)
}
