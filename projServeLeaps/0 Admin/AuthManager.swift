//
//  AuthManager.swift
//  projServeLeaps
//
//  Created by Tessa on 27/7/25.
//
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth


class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private let lastLoggedInUserKey = "lastLoggedInUser"
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.handleUserChange(user)
            }
        }
    }
    
    private func handleUserChange(_ user: User?) {
        let previousUserUID = UserDefaults.standard.string(forKey: lastLoggedInUserKey)
        let currentUserUID = user?.uid
        
        if let currentUID = currentUserUID {
            // User is logged in
            if previousUserUID != currentUID {
                // Different user logged in - clear all data
                print("New user detected, clearing all data")
                clearAllUserData()
                UserDefaults.standard.set(currentUID, forKey: lastLoggedInUserKey)
            }
            
            self.currentUser = user
            self.isLoggedIn = true
            
        } else {
            // User signed out
            self.currentUser = nil
            self.isLoggedIn = false
            clearAllUserData()
            UserDefaults.standard.removeObject(forKey: lastLoggedInUserKey)
        }
    }
    
    private func clearAllUserData() {
        // Clear all UserDefaults
        let userDefaultsKeys = [
            "userName", "userYear", "userHouse", "userCCA", "userPoints", "userState", "userProfileImage",
            "participationHistory", "lastSavedYear", "lastSavedPercentage"
        ]
        
        for key in userDefaultsKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        // Notify all data classes to reset
        NotificationCenter.default.post(name: .userDidChange, object: nil)
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

extension Notification.Name {
    static let userDidChange = Notification.Name("userDidChange")
}
