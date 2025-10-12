//
//  Service.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ServiceEvent: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var hours: Int
    var type: String
}

class ServiceData: ObservableObject {
    @Published var total_hours = 0
    @Published var level = "0"
    @Published var hexes: [ServiceEvent] = []
    @Published var serviceVIA = 0
    @Published var serviceSIP = 0

    private let db = Firestore.firestore()
    private var uid: String? { Auth.auth().currentUser?.uid }
    private var listener: ListenerRegistration?

    init() {
        loadServiceEvents()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDidChange),
            name: .userDidChange,
            object: nil
        )
    }
    
    @objc private func handleUserDidChange() {
            total_hours = 0
            level = "0"
            hexes = []
            serviceVIA = 0
            serviceSIP = 0
            
            listener?.remove()
            
            loadServiceEvents()
        }
        
        deinit {
            listener?.remove()
            NotificationCenter.default.removeObserver(self)
        }

    func loadServiceEvents() {
        guard let uid = uid else {
            print("No user ID found")
            return
        }
        
        // Remove existing listener if any
        listener?.remove()
        
        listener = db.collection("users").document(uid)
            .collection("serviceEvents")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error loading service events: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                DispatchQueue.main.async {
                    self.hexes = documents.compactMap { document in
                        do {
                            return try document.data(as: ServiceEvent.self)
                        } catch {
                            print("Error decoding service event: \(error)")
                            return nil
                        }
                    }
                    print("Loaded \(self.hexes.count) service events")
                    self.calculateTotals()
                }
            }
    }

    func addServiceEvent(name: String, hours: Int, type: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else {
            print("No user ID for adding service event")
            completion(false)
            return
        }
        
        print("Adding service event: \(name), \(hours) hours, type: \(type)")
        
        let newEvent = ServiceEvent(id: nil, name: name, hours: hours, type: type)
        do {
            try db.collection("users").document(uid)
                .collection("serviceEvents")
                .addDocument(from: newEvent) { error in
                    if let error = error {
                        print("Failed to add service event: \(error)")
                        completion(false)
                    } else {
                        print("Successfully added service event: \(name)")
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error when adding service event: \(error)")
            completion(false)
        }
    }

    func updateServiceEvent(at index: Int, name: String, hours: Int, type: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid,
              index < hexes.count,
              let id = hexes[index].id else {
            print("Invalid parameters for updating service event")
            completion(false)
            return
        }
        
        print("Updating service event at index \(index): \(name)")
        
        let updatedEvent = ServiceEvent(id: id, name: name, hours: hours, type: type)
        do {
            try db.collection("users").document(uid)
                .collection("serviceEvents").document(id)
                .setData(from: updatedEvent) { error in
                    if let error = error {
                        print("Failed to update service event: \(error)")
                        completion(false)
                    } else {
                        print("Successfully updated service event: \(name)")
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error when updating service event: \(error)")
            completion(false)
        }
    }

    func removeServiceEvent(at index: Int, completion: ((Bool) -> Void)? = nil) {
        guard let uid = uid,
              index < hexes.count,
              let id = hexes[index].id else {
            print("Invalid parameters for removing service event")
            completion?(false)
            return
        }
        
        let eventName = hexes[index].name
        print("Removing service event: \(eventName)")
        
        db.collection("users").document(uid)
            .collection("serviceEvents").document(id)
            .delete { error in
                if let error = error {
                    print("Failed to delete service event: \(error)")
                    completion?(false)
                } else {
                    print("Successfully deleted service event: \(eventName)")
                    completion?(true)
                }
            }
    }

    private func calculateTotals() {
        total_hours = hexes.reduce(0) { $0 + $1.hours }
        serviceVIA = hexes.filter { $0.type == "VIA for school/community" }.count
        serviceSIP = hexes.filter { $0.type == "SIP for school/community" }.count
        
        print("Calculated totals - Hours: \(total_hours), VIA: \(serviceVIA), SIP: \(serviceSIP)")
        updateLevel()
    }

    func updateLevel() {
        let oldLevel = level
        
        if total_hours < 24 && serviceVIA == 0 && serviceSIP < 1 {
            self.level = "0"
        } else if total_hours >= 24 && total_hours <= 30 && serviceVIA == 0 && serviceSIP < 1 {
            self.level = "1"
        } else if total_hours > 30 && total_hours <= 36 && serviceVIA == 0 && serviceSIP < 1 {
            self.level = "2"
        } else if serviceVIA == 1 && total_hours <= 24 && serviceSIP < 1 {
            self.level = "2"
        } else if total_hours > 36 && serviceVIA == 0 && serviceSIP < 1 {
            self.level = "3"
        } else if serviceVIA >= 2 && total_hours < 24 && serviceSIP < 1 {
            self.level = "3"
        } else if total_hours >= 24 && serviceVIA == 1 && serviceSIP < 1 {
            self.level = "3"
        } else if total_hours >= 24 && serviceVIA >= 2 && serviceSIP < 1 {
            self.level = "4"
        } else if total_hours >= 24 && serviceSIP >= 1 && serviceVIA >= 1 {
            self.level = "5" // This looks like it should be level 5, not 1
        }
        
        if oldLevel != level {
            print("Level updated from \(oldLevel) to \(level)")
        }
    }
}
