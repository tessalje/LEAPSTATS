//
//  UserData.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import Firebase

class UserData: ObservableObject, Identifiable {
    @Published var name: String = "My Name" {
        didSet { saveField("name", value: name) }
    }
    @Published var year: Int = 2025 {
        didSet { saveField("year", value: year) }
    }
    @Published var house: String = "My House" {
        didSet { saveField("house", value: house) }
    }
    @Published var cca: String = "My CCA" {
        didSet { saveField("cca", value: cca) }
    }
    @Published var points: Int = 0 {
        didSet { UserDefaults.standard.set(points, forKey: "userPoints") }
    }
    @Published var state: String = "Fair" {
        didSet { UserDefaults.standard.set(state, forKey: "userState") }
    }
    @Published var profileImageData: Data? = nil {
        didSet {
            if let data = profileImageData {
                UserDefaults.standard.set(data, forKey: "userProfileImage")
            } else {
                UserDefaults.standard.removeObject(forKey: "userProfileImage")
            }
        }
    }
    
    @Published var levelPointsData: LevelPointsData = LevelPointsData()
    
    private let db = Firestore.firestore()
    private var uid: String? { Auth.auth().currentUser?.uid }
    private var listener: ListenerRegistration?
    
    init() {
        self.loadLocalData()
        self.listenToFirestore()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDidChange),
            name: .userDidChange,
            object: nil
        )
    }
    
    @objc private func handleUserDidChange() {
        
        listener?.remove()
        
        listenToFirestore()
    }
    
    private func loadLocalData() {
        name = UserDefaults.standard.string(forKey: "userName") ?? "My Name"
        year = UserDefaults.standard.object(forKey: "userYear") as? Int ?? 2025
        house = UserDefaults.standard.string(forKey: "userHouse") ?? "My House"
        cca = UserDefaults.standard.string(forKey: "userCCA") ?? "My CCA"
        points = UserDefaults.standard.object(forKey: "userPoints") as? Int ?? 0
        state = UserDefaults.standard.string(forKey: "userState") ?? "Fair"
        profileImageData = UserDefaults.standard.data(forKey: "userProfileImage")
        levelPointsData = LevelPointsData()
        if year == 0 { year = 2025 }
    }
    
    private func listenToFirestore() {
        guard let uid = uid else { return }
        listener = db.collection("users").document(uid).addSnapshotListener { document, error in
            guard let data = document?.data(), error == nil else { return }
            DispatchQueue.main.async {
                self.name = data["name"] as? String ?? self.name
                self.year = data["year"] as? Int ?? self.year
                self.house = data["house"] as? String ?? self.house
                self.cca = data["cca"] as? String ?? self.cca
                self.saveLocal()
            }
        }
    }
    
    private func saveField(_ key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: "user\(key.capitalized)")
        guard let uid = uid else { return }
        db.collection("users").document(uid).setData([key: value], merge: true)
    }
    
    private func saveLocal() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(year, forKey: "userYear")
        UserDefaults.standard.set(house, forKey: "userHouse")
        UserDefaults.standard.set(cca, forKey: "userCCA")
    }
    
    func resetToDefaults() {
        name = "My Name"
        year = 2025
        house = "My House"
        cca = "My CCA"
        points = 0
        state = "Fair"
        profileImageData = nil
        levelPointsData = LevelPointsData()
    }
    
    func clearStoredData() {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userYear")
        UserDefaults.standard.removeObject(forKey: "userHouse")
        UserDefaults.standard.removeObject(forKey: "userCCA")
        UserDefaults.standard.removeObject(forKey: "userPoints")
        UserDefaults.standard.removeObject(forKey: "userState")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
    }
    
    func attainment(leadership: LeadershipData, service: ServiceData, participation: ParticipationData, achievements: AchievementsData) -> String {
        let leadershipLevel = Int(leadership.currentLevel) ?? 0
        let achievementsLevel = Int(achievements.currentHighestLevel) ?? 0
        let participationLevel = Int(participation.level) ?? 0
        let serviceLevel = Int(service.level) ?? 0
        
        let domainlevels = [leadershipLevel, achievementsLevel, participationLevel, serviceLevel]
        
        let level1OrAbove = domainlevels.filter { $0 >= 1 }.count
        let level2OrAbove = domainlevels.filter { $0 >= 2 }.count
        let level3OrAbove = domainlevels.filter { $0 >= 3 }.count
        let level4OrAbove = domainlevels.filter { $0 >= 4 }.count
        
        if level3OrAbove >= 4 && level4OrAbove >= 1 {
            return "Excellent"
        } else if level1OrAbove == 4 {
            if level2OrAbove >= 3 {
                return "Good"
            } else if level2OrAbove >= 1 && level3OrAbove >= 1 {
                return "Good"
            } else if level4OrAbove >= 1 {
                return "Good"
            }
        }
        return "Fair"
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
}


struct LevelPoints: Codable, Identifiable {
    var id = UUID()
    var level_one: Int = 0
    var level_two: Int = 0
    var level_three: Int = 0
    var level_four: Int = 0
    var level_five: Int = 0
}

class LevelPointsData: ObservableObject {
    @Published var levelPoints = LevelPoints()
    
    func calculatePoints(leadership: LeadershipData, service: ServiceData, participation: ParticipationData, achievements: AchievementsData) {
        levelPoints = LevelPoints()
        
        if let leadershipLevel = Int(leadership.currentLevel) {
            addPointToLevel(leadershipLevel)
            print("leadership: \(leadershipLevel)")
        }
        if let serviceLevel = Int(service.level) {
            addPointToLevel(serviceLevel)
            print("service: \(serviceLevel)")
        }
        if let achievementsLevel = Int(achievements.currentHighestLevel) {
            addPointToLevel(achievementsLevel)
            print("leadership: \(achievementsLevel)")
        }
        
        if let participationLevel = Int(participation.level) {
            addPointToLevel(participationLevel)
            print("participation: \(participationLevel)")
        }
    }
    
    private func addPointToLevel(_ level: Int) {
        switch level {
        case 1:
            levelPoints.level_one += 1
            print("level 1 + 1")
        case 2:
            levelPoints.level_two += 1
            print("level 2 + 1")
        case 3:
            levelPoints.level_three += 1
            print("level 3 + 1")
        case 4:
            levelPoints.level_four += 1
            print("level 4 + 1")
        case 5:
            levelPoints.level_five += 1
            print("level 5 + 1")
        default:
            break
        }
    }
}
