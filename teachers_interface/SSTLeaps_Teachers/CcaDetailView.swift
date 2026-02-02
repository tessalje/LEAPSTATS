//
//  CcaDetailView.swift
//  SSTLeaps_Teachers
//
//  Created by Kesler Ang Kang Zhi on 6/7/25.
//
import SwiftUI
struct Student: Identifiable {
    let name: String
    let classes: String
    let leaps_level: String
    let id = UUID()
}
struct CcaDetailView: View {
    let student_items: [Student] = [
        Student(name: "Kesler Ang Kang Zhi", classes: "S3-05", leaps_level: "5"),
        Student(name: "Tessa Lee", classes: "S3-03", leaps_level: "2"),
    ]
    let item: HexagonItem

    var body: some View {
        VStack {
            Text(item.title)
                .font(.largeTitle)
                .padding()
            detailContent(for: item)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }

    @ViewBuilder
    func detailContent(for item: HexagonItem) -> some View {
        switch item.title {
        case "Astronomy Club":
            Text("Details and chart for Astronomy Club")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Guitar Ensemble":
            Text("Details and chart for Guitar Ensemble")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "ARC @SST":
            Text("Details and chart for ARC @SST")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Floorball":
            Text("Details and chart for Floorball")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Media Club":
            Text("Details and chart for Media Club")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Athletics (Track)":
            Text("Details and chart for Athletics (Track)")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Robotics @APEX":
            Text("Details and chart for Robotics @APEX")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Badminton":
            Text("Details and chart for Badminton")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Scouts":
            Text("Details and chart for Scouts")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Basketball":
            Text("Details and chart for Basketball")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Show Choir and Dance":
            Text("Details and chart for Show Choir and Dance")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "English Drama Club":
            Text("Details and chart for English Drama Club")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
            
        case "Football":
            Text("Details and chart for Football")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Fencing":
            Text("Details and chart for Fencing")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        case "Taekwondo":
            Text("Details and chart for Taekwondo")
            Table(student_items) {
                TableColumn("Name", value: \.name)
                TableColumn("Classes", value: \.classes)
            }
        default:
            Text("No detail available for this CCA")
        }
    }
}
