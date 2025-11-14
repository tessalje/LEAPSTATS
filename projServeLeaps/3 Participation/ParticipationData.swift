//
//  Participation.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//
//
//  Participation.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine
 
struct GoogleSheetResponse: Codable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}

class GoogleSheetsService: ObservableObject {
    @Published var attendance: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var missedSessions: Int = 0
    
    private let apiKey = "AIzaSyCOyhVCnGxvWz0Ds-_-3knCOuo_d_FDDIU"
    private let spreadsheetId = "1R7JwhmOwkEVUNPzPTGzedaiZALz62xAHmDt3JsHDR0M"
    
    func fetchAttendance(startingRow: Int, numberOfRows: Int, filterName: String) {
        isLoading = true
        errorMessage = nil
        
        let endRow = startingRow + numberOfRows - 1
        let range = "A\(startingRow):Z\(endRow)"
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let sheetResponse = try JSONDecoder().decode(GoogleSheetResponse.self, from: data)
                    let (attendanceValue, missedValue) = self?.extractAttendance(from: sheetResponse.values, filterName: filterName) ?? (0, 0)
                    self?.attendance = attendanceValue
                    self?.missedSessions = missedValue
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func extractAttendance(from values: [[String]], filterName: String) -> (Int, Int) {
        guard !values.isEmpty else { return (0, 0) }
        
        // Get the header row (first row)
        let headerRow = values[0].map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        // Find column index for "total" or "attendance"
        let attendanceIndex = headerRow.firstIndex(where: { $0.contains("total") || $0.contains("attendance") })
        
        // Find column index for "missed"
        let missedIndex = headerRow.firstIndex(where: { $0.contains("missed") })
        
        // Look for the matching student name in column A
        for (index, row) in values.enumerated() where index > 0 {
            let name = row.first?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
            if name == filterName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                var attendanceValue = 0
                var missedValue = 0
                
                // Extract attendance
                if let attendanceIndex = attendanceIndex, row.count > attendanceIndex {
                    attendanceValue = Int(row[attendanceIndex].filter("0123456789".contains)) ?? 0
                }
                
                // Extract missed sessions
                if let missedIndex = missedIndex, row.count > missedIndex {
                    missedValue = Int(row[missedIndex].filter("0123456789".contains)) ?? 0
                }
                
                return (attendanceValue, missedValue)
            }
        }
        return (0, 0)
    }
}

class ParticipationData: ObservableObject {
    @Published var attendance: Int = 80
    @Published var year: Int = 3
    @Published var level = "3" //fix this
    @Published var studentName: String = "Pavithraa"
    @Published var missedSessions: Int = 0
    
    private var db = Firestore.firestore()
    @Published var googleSheetsService = GoogleSheetsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindGoogleSheetsAttendance()
        fetchUserNameAndLoadData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDidChange),
            name: .userDidChange,
            object: nil
        )
    }
    
    @objc private func handleUserDidChange() {
        attendance = 80
        year = 3
        level = "3"
        studentName = "Pavithraa"
        missedSessions = 0
        googleSheetsService = GoogleSheetsService()
        
        cancellables.removeAll()
        bindGoogleSheetsAttendance()
        fetchUserNameAndLoadData()
    }
    
    private func bindGoogleSheetsAttendance() {
        googleSheetsService.$attendance
            .receive(on: RunLoop.main)
            .assign(to: \.attendance, on: self)
            .store(in: &cancellables)
        
        googleSheetsService.$missedSessions
            .receive(on: RunLoop.main)
            .assign(to: \.missedSessions, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchUserNameAndLoadData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            fetchGoogleSheetsData(studentName: studentName)
            return
        }
        
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let data = snapshot?.data() {
                if let name = data["name"] as? String, !name.isEmpty {
                    self.studentName = name
                }
                self.year = data["participationYear"] as? Int ?? 3
                self.fetchGoogleSheetsData(studentName: self.studentName)
            } else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                self.fetchGoogleSheetsData(studentName: self.studentName)
            }
        }
    }
    
    func fetchGoogleSheetsData(studentName: String) {
        googleSheetsService.fetchAttendance(
            startingRow: 1,
            numberOfRows: 100,
            filterName: studentName
        )
    }
    
    func refreshData() {
        fetchUserNameAndLoadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
