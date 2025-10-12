//
//  sheets.swift
//  projServeLeaps
//
//  Created by Tessa on 1/7/25.
//

//
//import SwiftUI
//import Foundation
//
//// MARK: - Models
//struct SheetsResponse: Codable {
//    let values: [[String]]?
//}
//
//// MARK: - Google Sheets Service
//class GoogleSheetsService: ObservableObject {
//    @Published var averagePercentage: Double = 0.0
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let apiKey = "YOUR_API_KEY_HERE" // Replace with your actual API key
//    private let spreadsheetId = "YOUR_SPREADSHEET_ID_HERE" // Replace with your spreadsheet ID
//    private let range = "Sheet1!A:A" // Adjust range as needed
//    
//    func fetchDataAndCalculateAverage() {
//        isLoading = true
//        errorMessage = nil
//        
//        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)"
//        
//        guard let url = URL(string: urlString) else {
//            errorMessage = "Invalid URL"
//            isLoading = false
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                
//                if let error = error {
//                    self?.errorMessage = "Network error: \(error.localizedDescription)"
//                    return
//                }
//                
//                guard let data = data else {
//                    self?.errorMessage = "No data received"
//                    return
//                }
//                
//                do {
//                    let sheetsResponse = try JSONDecoder().decode(SheetsResponse.self, from: data)
//                    self?.processData(sheetsResponse.values ?? [])
//                } catch {
//                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//    }
//    
//    private func processData(_ values: [[String]]) {
//        var numbers: [Double] = []
//        
//        for row in values {
//            for cell in row {
//                // Try to convert cell value to Double
//                if let number = Double(cell.trimmingCharacters(in: .whitespacesAndNewlines)) {
//                    numbers.append(number)
//                }
//            }
//        }
//        
//        guard !numbers.isEmpty else {
//            errorMessage = "No valid numbers found in the sheet"
//            return
//        }
//        
//        // Calculate sum and average
//        let sum = numbers.reduce(0, +)
//        let average = sum / Double(numbers.count)
//        
//        // If you want percentage, multiply by 100 or use as-is if already percentages
//        self.averagePercentage = average
//    }
//}
//
//// MARK: - SwiftUI View
//struct ContentView: View {
//    @StateObject private var sheetsService = GoogleSheetsService()
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 30) {
//                // Title
//                Text("Google Sheets Data")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                
//                // Average Display
//                VStack(spacing: 10) {
//                    Text("Average Percentage")
//                        .font(.headline)
//                        .foregroundColor(.secondary)
//                    
//                    Text("\(sheetsService.averagePercentage, specifier: "%.2f")%")
//                        .font(.system(size: 48, weight: .bold, design: .rounded))
//                        .foregroundColor(.blue)
//                }
//                .padding()
//                .background(Color.blue.opacity(0.1))
//                .cornerRadius(15)
//                
//                // Fetch Button
//                Button(action: {
//                    sheetsService.fetchDataAndCalculateAverage()
//                }) {
//                    HStack {
//                        if sheetsService.isLoading {
//                            ProgressView()
//                                .scaleEffect(0.8)
//                        } else {
//                            Image(systemName: "arrow.clockwise")
//                        }
//                        Text(sheetsService.isLoading ? "Loading..." : "Fetch Data")
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(sheetsService.isLoading ? Color.gray : Color.blue)
//                    .cornerRadius(10)
//                }
//                .disabled(sheetsService.isLoading)
//                
//                // Error Message
//                if let errorMessage = sheetsService.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Sheets Calculator")
//        }
//    }
//}
//
//// MARK: - App
//@main
//struct SheetsApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//
//// MARK: - Setup Instructions
///*
//Setup Instructions:
//
//1. Enable Google Sheets API:
//   - Go to Google Cloud Console (console.cloud.google.com)
//   - Create a new project or select existing one
//   - Enable the Google Sheets API
//   - Create credentials (API key)
//
//2. Get your Spreadsheet ID:
//   - Open your Google Sheet
//   - Copy the ID from the URL (between /d/ and /edit)
//   - Example: https://docs.google.com/spreadsheets/d/SPREADSHEET_ID_HERE/edit
//
//3. Make your sheet public or set up OAuth:
//   - For public access: Share > Anyone with the link can view
//   - For private access: Implement OAuth 2.0 (more complex)
//
//4. Update the code:
//   - Replace "YOUR_API_KEY_HERE" with your actual API key
//   - Replace "YOUR_SPREADSHEET_ID_HERE" with your spreadsheet ID
//   - Adjust the range ("Sheet1!A:A") to match your data location
//
//5. Add network permissions in Info.plist:
//   <key>NSAppTransportSecurity</key>
//   <dict>
//       <key>NSAllowsArbitraryLoads</key>
//       <true/>
//   </dict>
//
//Usage Notes:
//- This code assumes your sheet contains numeric values
//- It will sum all numbers and calculate the average
//- The range "Sheet1!A:A" reads column A - adjust as needed
//- For multiple columns, use "Sheet1!A:C" or "Sheet1!A1:C10"
//- Error handling is included for network and parsing issues
//*/
