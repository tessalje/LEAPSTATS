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

class ParticipationData: ObservableObject {
    @Published var attendance: Int = 80
    @Published var year: Int = 3
    @Published var level = "3"
    @Published var sheetsPercentage: Int = 0
    
    private var db = Firestore.firestore()
    @Published var googleSheetsService = GoogleSheetsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupGoogleSheetsBinding()
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
        sheetsPercentage = 0
        googleSheetsService = GoogleSheetsService()
        
        cancellables.removeAll()
        setupGoogleSheetsBinding()
    }
    
    private func setupGoogleSheetsBinding() {
        googleSheetsService.$cellPairs
            .map { pairs in
                if let firstPair = pairs.first,
                   let percentage = Int(firstPair.rightValue) {
                    return percentage
                } else {
                    return 0
                }
            }
            .assign(to: \.sheetsPercentage, on: self)
            .store(in: &cancellables)
    }
    
    func fetchParticipation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.attendance = data["participationAttendance"] as? Int ?? 0
                self.year = data["participationYear"] as? Int ?? 1
            } else {
                print("Error fetching participation data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchGoogleSheetsData(studentName: String) {
        googleSheetsService.fetchFilteredData(
            startingRow: 1,
            numberOfRows: 100,
            filterName: studentName
        )
    }
    
    var currentPercentage: Int {
        sheetsPercentage > 0 ? sheetsPercentage : attendance
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct YearParticipation: Codable, Identifiable {
    var id = UUID()
    let year: String
    let cca: String
    let percentage: Int
}

struct CellPair: Identifiable {
    let id = UUID()
    let leftValue: String
    let rightValue: String
    let rowNumber: Int
}

class GoogleSheetsService: ObservableObject {
    @Published var cellPairs: [CellPair] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "AIzaSyCOyhVCnGxvWz0Ds-_-3knCOuo_d_FDDIU"
    private let spreadsheetId = "1R7JwhmOwkEVUNPzPTGzedaiZALz62xAHmDt3JsHDR0M"
    
    func fetchFilteredData(startingRow: Int, numberOfRows: Int, filterName: String) {
        isLoading = true
        errorMessage = nil
        cellPairs = []
        
        let endRow = startingRow + numberOfRows - 1
        let range = "A\(startingRow):F\(endRow)"
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
                    self?.processFilteredData(sheetResponse.values, startingRow: startingRow, filterName: filterName)
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func processFilteredData(_ values: [[String]], startingRow: Int, filterName: String) {
        var filteredPairs: [CellPair] = []
        
        for (index, row) in values.enumerated() {
            let currentRow = startingRow + index
            
            let columnAValue = row.count > 0 ? row[0] : ""
            
            if columnAValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
                filterName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                
                let columnFValue = row.count > 5 ? row[5] : ""
                
                let pair = CellPair(
                    leftValue: columnAValue,
                    rightValue: columnFValue,
                    rowNumber: currentRow
                )
                filteredPairs.append(pair)
            }
        }
        
        self.cellPairs = filteredPairs
    }
}

struct GoogleSheetResponse: Codable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}


struct ParticipationHexagon: View {
    var percentage: String
    var name: String
    
    var textColor: Color {
        .black
    }
    
    var backgroundColor: Color {
        Color.blue.opacity(0.3)
    }
    
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(backgroundColor)
                .frame(width: 150, height: 160)
                .rotationEffect(.degrees(90))
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Text("\(percentage)")
                            .foregroundColor(textColor)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .lineLimit(nil)
                        
                        Text("\(name)")
                            .foregroundColor(textColor)
                            .multilineTextAlignment(.center)
                    }
                )
        }
    }
}


struct ParticipationHexagon2: View {
    @State var percentage: String
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    var level: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                HexagonView()
                    .foregroundStyle(Color.blue)
                    .frame(width: 250, height: 280)
                    .opacity(0.2)
                    .compositingGroup()
                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 10)
                    .padding()
                VStack {
                    Text("\(percentage)")
                        .foregroundColor(.black)
                        .font(.title2)
                    Text("\(level)")
                        .foregroundColor(.black)
                        .font(.title2)
                }
            }
        }
    }
}

class ParticipationHistoryViewModel: ObservableObject {
    @Published var history: [YearParticipation] = []
    @EnvironmentObject var participation: ParticipationData
    @EnvironmentObject var user: UserData
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let historyKey = "participationHistory"
    private let lastSavedYearKey = "lastSavedYear"
    private let lastSavedPercentageKey = "lastSavedPercentage"
    
    init(currentPercentage: Int) {
        loadHistory()
        checkAndSaveCurrentYear(percentage: currentPercentage)
    }
    
    private func loadHistory() {
        history = [
            YearParticipation(year: "2021", cca: user.cca, percentage: 75),
            YearParticipation(year: "2022", cca: user.cca, percentage: 85),
            YearParticipation(year: "2023", cca: user.cca, percentage: 85),
        ]
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    private func checkAndSaveCurrentYear(percentage: Int) {
        let lastSavedYear = UserDefaults.standard.integer(forKey: lastSavedYearKey)
        
        if currentYear != lastSavedYear {
            let currentYearParticipation = YearParticipation(
                year: String(currentYear),
                cca: "Current Activity",
                percentage: percentage
            )
            history.append(currentYearParticipation)
            
            UserDefaults.standard.set(currentYear, forKey: lastSavedYearKey)
            UserDefaults.standard.set(percentage, forKey: lastSavedPercentageKey)
            saveHistory()
        }
    }
    
    func calculateLevel() -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentYearData = YearParticipation(
            year: String(currentYear),
            cca: "Current Activity",
            percentage: UserDefaults.standard.integer(forKey: lastSavedPercentageKey)
        )

        var allEntries = history
        if currentYearData.percentage >= 75 {
            allEntries.append(currentYearData)
        }

        let qualifying = allEntries.filter { $0.percentage >= 75 }
        let yearsCount = qualifying.count

        switch yearsCount {
        case 2:
            return 1
        case 3:
            return 2
        case 4...:
            return 3
        default:
            return 0
        }
    }
}

struct ParticipationHexagon2Advanced: View {
    @ObservedObject var participationData: ParticipationData
    @StateObject private var viewModel: ParticipationHistoryViewModel
    
    init(participationData: ParticipationData) {
        self.participationData = participationData
        _viewModel = StateObject(wrappedValue: ParticipationHistoryViewModel(currentPercentage: participationData.currentPercentage))
    }

    var calculatedLevel: Int {
        viewModel.calculateLevel()
    }
    
    var hexagonColor: Color {
        calculatedLevel >= 3 ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.red
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ZStack {
                    HexagonView()
                        .foregroundStyle(hexagonColor)
                        .frame(width: 250, height: 280)
                        .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 10)
                        .padding()
                    
                    VStack(spacing: 8) {
                        Text("\(participationData.currentPercentage) %")
                            .foregroundColor(.black)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Level \(calculatedLevel)")
                            .foregroundColor(.black)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }
                
                if participationData.googleSheetsService.isLoading {
                    ProgressView("Loading participation data...")
                        .padding()
                }
                
                if let errorMessage = participationData.googleSheetsService.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Previous Years:")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    ForEach(viewModel.history) { item in
                        HStack {
                            Text("\(item.year): \(item.cca)")
                                .foregroundColor(.black)
                                .font(.subheadline)
                            Spacer()
                            Text("\(item.percentage)%")
                                .foregroundColor(item.percentage >= 75 ? .green : .red)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct Participation2View: View {
    @StateObject private var participationData = ParticipationData()
    @State private var studentName = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Student Name", text: $studentName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack(spacing: 15) {
                Button("Fetch Firebase Data") {
                    participationData.fetchParticipation()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Fetch Sheets Data") {
                    if !studentName.isEmpty {
                        participationData.fetchGoogleSheetsData(studentName: studentName)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(studentName.isEmpty)
            }
            
            ParticipationHexagon2Advanced(participationData: participationData)
        }
        .onAppear {
            participationData.fetchParticipation()
        }
    }
}
