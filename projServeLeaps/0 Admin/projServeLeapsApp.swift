//
//  projServeLeapsApp.swift
//  projServeLeaps
//
//  Created by Vijayaganapathy Pavithraa on 24/6/25.
//

import SwiftUI
import FirebaseCore
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
  }
}

@main
struct projServeLeapsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager()
    @StateObject private var userManager = UserManager.shared
    @StateObject private var leadership = LeadershipData()
    @StateObject private var participation = ParticipationData()
    @StateObject private var service = ServiceData()
    @StateObject private var achievement = AchievementsData()
    @StateObject private var userData = UserData()

    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                ContentView()
                    .environmentObject(leadership)
                    .environmentObject(participation)
                    .environmentObject(service)
                    .environmentObject(achievement)
                    .environmentObject(userManager)
                    .environmentObject(userData)
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(userManager)
                    .environmentObject(leadership)
                    .environmentObject(participation)
                    .environmentObject(service)
                    .environmentObject(achievement)
                    .environmentObject(userData)
                    .environmentObject(authManager)
            }
        }
    }
}

