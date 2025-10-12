//
//  Leadership.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct LeadershipPositions: Codable, Identifiable {
    var id: String
    var name: String
    var year: Int
    var level: String
}

class LeadershipData: ObservableObject {
    @Published var leadershipHexes: [LeadershipPositions] = []
    @Published var currentLeadershipPosition: String = "No role"
    @Published var currentLevel: String = "0"
    
    private let db = Firestore.firestore()
    private var userID: String? { Auth.auth().currentUser?.uid }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDidChange),
            name: .userDidChange,
            object: nil
        )
    }
    
    @objc private func handleUserDidChange() {
        leadershipHexes = []
        currentLeadershipPosition = "No role"
        currentLevel = "0"
        loadLeadershipPositions()
    }
    
    func loadLeadershipPositions() {
        guard let uid = userID else { return }
        db.collection("users").document(uid).collection("leadership").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching leadership data: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.leadershipHexes = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let year = data["year"] as? Int,
                          let level = data["level"] as? String else { return nil }
                    return LeadershipPositions(id: doc.documentID, name: name, year: year, level: level)
                } ?? []
                self.updateCurrentHighestLevel()
            }
        }
    }
    
    func addLeadershipPosition(name: String, year: Int) {
        guard let uid = userID else { return }
        let level = getLevelForPosition(name)
        
        // Create the document reference and get the ID
        let docRef = db.collection("users").document(uid).collection("leadership").document()
        let newPosition = LeadershipPositions(id: docRef.documentID, name: name, year: year, level: level)
        
        // First update the UI immediately for better UX
        DispatchQueue.main.async {
            self.leadershipHexes.append(newPosition)
            self.updateCurrentHighestLevel()
        }
        
        // Then save to Firebase
        docRef.setData([
            "name": name,
            "year": year,
            "level": level
        ]) { error in
            if let error = error {
                print("Failed to add position: \(error)")
                // Remove from UI if Firebase save failed
                DispatchQueue.main.async {
                    if let index = self.leadershipHexes.firstIndex(where: { $0.id == newPosition.id }) {
                        self.leadershipHexes.remove(at: index)
                        self.updateCurrentHighestLevel()
                    }
                }
            } else {
                print("Successfully added position: \(name)")
            }
        }
    }
    
    func updateLeadershipPosition(at index: Int, name: String, year: Int) {
        guard let uid = userID, index < leadershipHexes.count else { return }
        let id = leadershipHexes[index].id
        let level = getLevelForPosition(name)
        let updatedData = ["name": name, "year": year, "level": level] as [String : Any]
        
        // Update UI first
        DispatchQueue.main.async {
            self.leadershipHexes[index] = LeadershipPositions(id: id, name: name, year: year, level: level)
            self.updateCurrentHighestLevel()
        }
        
        // Then update Firebase
        db.collection("users").document(uid).collection("leadership").document(id).setData(updatedData) { error in
            if let error = error {
                print("Update failed: \(error)")
                // You might want to revert the UI change here if needed
            } else {
                print("Successfully updated position: \(name)")
            }
        }
    }
    
    func removeLeadershipPosition(at index: Int) {
        guard let uid = userID, index < leadershipHexes.count else { return }
        let id = leadershipHexes[index].id
        let removedPosition = leadershipHexes[index]
        
        // Update UI first
        DispatchQueue.main.async {
            self.leadershipHexes.remove(at: index)
            self.updateCurrentHighestLevel()
        }
        
        // Then delete from Firebase
        db.collection("users").document(uid).collection("leadership").document(id).delete { error in
            if let error = error {
                print("Delete failed: \(error)")
                // Restore the item if deletion failed
                DispatchQueue.main.async {
                    self.leadershipHexes.insert(removedPosition, at: index)
                    self.updateCurrentHighestLevel()
                }
            } else {
                print("Successfully deleted position: \(removedPosition.name)")
            }
        }
    }
    
    private func updateCurrentHighestLevel() {
        guard !leadershipHexes.isEmpty else {
            currentLeadershipPosition = "No role"
            currentLevel = "0"
            return
        }
        
        let highest = leadershipHexes.max(by: { (lhs, rhs) in
            (Int(lhs.level) ?? 0) < (Int(rhs.level) ?? 0)
        })
        
        if let top = highest {
            currentLeadershipPosition = top.name
            currentLevel = top.level
        }
    }
    
    func getLevelForPosition(_ position: String) -> String {
        if Self.levelOneArray.contains(position) { return "1" }
        if Self.levelTwoArray.contains(position) { return "2" }
        if Self.levelThreeArray.contains(position) { return "3" }
        if Self.levelFourArray.contains(position) { return "4" }
        if Self.levelFiveArray.contains(position) { return "5" }
        return "0"
    }
    
    static func getPositionsForCategory(_ category: String) -> [String] {
        switch category {
        case "ACE Board": return aceArray
        case "PSB Board": return psbArray
        case "SC Board": return scArray
        case "DC Board": return dcArray
        case "House/SNW": return houseArray
        case "CCA Leaders": return ccaArray
        case "Projects Board": return projectArray
        case "Others": return othersArray
        default: return []
        }
    }
    
    static let allCategories = ["ACE Board", "PSB Board", "SC Board", "DC Board", "House/SNW", "Projects Board", "Others"]
    
    // All your static arrays remain the same...
    static let levelOneArray = [
        "Completed 2 modules on leadership",
    ]
    
    static let levelTwoArray = [
        "Class Exco",
        "Junior SNW Leader",
        "Committee for SIP",
        "Committee for SL",
        "Junior CCA Exco",
        "NYAA Bronze"
    ]
    
    static let levelThreeArray = [
        "Class Chairperson",
        "Class Vice-Chairperson",
        "Junior SC",
        "Junior PSB",
        "Junior ACE",
        "Junior DC",
        "Junior house captain",
        "Junior house vice-captain",
        "Senior Sports Leader",
        "Committee for school-wide events",
        "Chairperson for SIP",
        "Vice-Chairperson for SIP",
        "Chairperson for SL projects",
        "Vice-Chairperson for SL projects",
        "Junior CCA Chairperson",
        "Junior CCA Vice-Chairperson",
        "Junior CCA Exco",
        "NYAA Silver",
    ]
    
    static let levelFourArray = [
        "Senior SC",
        "Senior PSB",
        "Senior ACE",
        "Senior DC",
        "House Exco",
        "Senior House Captain",
        "Senior House Vice-Captain",
        "Senior CCA Exco",
        "Chairperson for school-wide events",
        "Vice-Chairperson for school-wide events",
    ]
    
    static let levelFiveArray = [
        "SC Exco",
        "PSB Exco",
        "ACE Exco",
        "DC Exco",
        "SC President",
        "SC Vice-President",
        "PSB President",
        "PSB Vice-President",
        "ACE President",
        "ACE Vice-President",
        "DC President",
        "DC Vice-President",
        "CCA Chairperson",
        "CCA Vice-Chairperson"
    ]
    
    // Category arrays
    static let dcArray = [
        "Junior DC", "Senior DC", "DC Exco", "DC President", "DC Vice-President"
    ]
    
    static let aceArray = [
        "Junior ACE", "Senior ACE", "ACE Exco", "ACE President", "ACE Vice-President"
    ]
    
    static let scArray = [
        "Junior SC", "Senior SC", "SC Exco", "SC President", "SC Vice-President"
    ]
    
    static let psbArray = [
        "Junior PSB", "Senior PSB", "PSB Exco", "PSB President", "PSB Vice-President"
    ]
    
    static let ccaArray = [
        "Junior CCA Chairperson", "Junior CCA Vice-Chairperson", "Junior CCA Exco",
        "Senior CCA Exco", "CCA Chairperson", "CCA Vice-Chairperson"
    ]
    
    static let houseArray = [
        "Junior house captain", "Junior house vice-captain", "House Exco",
        "Senior House Captain", "Senior House Vice-Captain", "Junior SNW Leader", "Senior Sports Leader"
    ]
    
    static let projectArray = [
        "Committee for SIP", "Chairperson for SIP", "Vice-Chairperson for SIP",
        "Committee for school-wide events", "Chairperson for school-wide events", "Vice-Chairperson for school-wide events",
        "Chairperson for SL projects", "Vice-Chairperson for SL projects", "Committee for SL"
    ]
    
    static let othersArray = [
        "NYAA Bronze", "NYAA Silver", "Class Chairperson", "Class Vice-Chairperson", "Class Exco", "Completed 2 modules on leadership"
    ]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
