//
//  SignUpView.swift
//  projServeLeaps
//
//  Created by Tessa on 13/7/25.
//

import SwiftUI
// SIGN UP VIEW
struct SignUpView: View {
    @EnvironmentObject var userManager: UserManager
    
    @State private var signupError: String? = nil
    @State private var isSignedUp: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Name", text: $name)
                    .padding()
                    .background(.lightGrey2)
                    .cornerRadius(12)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(.lightGrey2)
                    .cornerRadius(12)
                
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
                
                Button("Sign Up") {
                    guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                        signupError = "All fields are required."
                        return
                    }
                    userManager.signUp(name: name, email: email, password: password) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                signupError = nil
                                isSignedUp = true
                            case .failure(let error):
                                signupError = "Sign up failed: \(error.localizedDescription)"
                            }
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
                
                if let error = signupError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top)
            .background(.background)
            .preferredColorScheme(.light)
            //NAVIGATE UPON SIGN-UP
            .navigationDestination(isPresented: $isSignedUp) {
                            HomeView()
            }
        }
    }
}

