//
//  Achievements.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Achievement: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var award: String
    var representation: String
    var level: String
    var year: String
}

class AchievementsData: ObservableObject {
    @Published var hexes: [Achievement] = []
    @Published var name: String = "No awards"
    @Published var currentHighestLevel: String = "0"

    private let db = Firestore.firestore()
    private var uid: String? { Auth.auth().currentUser?.uid }
    
    init() {
        loadAchievements()
        
        // Listen for user changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDidChange),
            name: .userDidChange,
            object: nil
        )
    }
    
    @objc private func handleUserDidChange() {
            hexes = []
            name = "No awards"
            currentHighestLevel = "0"
            
            loadAchievements()
        }
    
    func loadAchievements() {
        guard let uid = uid else { return }
        db.collection("users").document(uid)
            .collection("achievements")
            .order(by: "level", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self.hexes = docs.compactMap {
                    try? $0.data(as: Achievement.self)
                }
                self.updateCurrentLevel()
            }
    }
    
    var achievementCount: Int {
        return hexes.count
    }
    
    private func computeLevel(for representation: String) -> String {
        switch representation {
        case "National (SG/MOE/UG HQ)": return "5"
        case "School/External Organisation": return "3"
        case "Intra-school": return "1"
        default: return "0"
        }
    }

    func addAchievement(name: String, award: String, representation: String, year: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else {
            completion(false)
            return
        }
        let level = computeLevel(for: representation)
        let new = Achievement(id: nil, name: name, award: award, representation: representation, level: level, year: year)
        do {
            try db.collection("users").document(uid)
                .collection("achievements")
                .addDocument(from: new) { error in
                    completion(error == nil)
                }
        } catch {
            completion(false)
        }
    }

    func updateAchievement(at index: Int, name: String, award: String, representation: String, year: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid,
              index < hexes.count,
              let id = hexes[index].id else {
            completion(false)
            return
        }
        let level = computeLevel(for: representation)
        let updated = Achievement(id: id, name: name, award: award, representation: representation, level: level, year: year)
        do {
            try db.collection("users").document(uid)
                .collection("achievements").document(id)
                .setData(from: updated) { error in
                    completion(error == nil)
                }
        } catch {
            completion(false)
        }
    }

    func removeAchievement(at index: Int) {
        guard let uid = uid,
              index < hexes.count,
              let id = hexes[index].id else { return }
        db.collection("users").document(uid)
            .collection("achievements").document(id)
            .delete()
    }

    private func updateCurrentLevel() {
        var nationalCount = 0
        var externalCount = 0
        var intraCount = 0
        var nationalYears: Set<String> = []
        var externalYears: Set<String> = []
        for achievement in hexes {
            switch achievement.representation {
            case "National (SG/MOE/UG HQ)":
                nationalCount += 1
                nationalYears.insert(achievement.year)
            case "School/External Organisation":
                externalCount += 1
                externalYears.insert(achievement.year)
            case "Intra-school":
                intraCount += 1
            default:
                break
            }
        }
        if nationalCount >= 2 && nationalYears.count >= 2 {
            currentHighestLevel = "5"
        } else if nationalCount >= 1 && externalCount >= 2 {
            currentHighestLevel = "4"
        } else if externalCount >= 2 {
            currentHighestLevel = "3"
        } else if externalCount >= 1 {
            currentHighestLevel = "2"
        } else if intraCount >= 1 {
            currentHighestLevel = "1"
        } else {
            currentHighestLevel = "0" 
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
