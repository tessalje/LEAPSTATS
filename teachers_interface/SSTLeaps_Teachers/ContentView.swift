//
//  ContentView.swift
//  SSTLeaps_Teachers
//
//  Created by Kesler Ang Kang Zhi on 1/7/25.
//
import SwiftUI
struct HexagonItem: Identifiable {
    enum Section {
        case left, middle, right
    }
    let id = UUID()
    let title: String
    let x: CGFloat
    let y: CGFloat
    let isCenter: Bool
    let section: Section
    let font: Font
}
struct ContentView: View {
    var teacher_name = "RUTH LOH"
    var body: some View {
        NavigationStack {
            VStack {
                CCAView()
                Spacer()
            }
            .toolbar {
                ToolbarItem() {
                    HStack(spacing: 8) {
                        Text(teacher_name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                    }
                }
            }
        }
    }
}

struct CCAView: View {
    let items: [HexagonItem] = [
        // Left section - Red
        .init(title: "Astronomy Club", x: 100, y: 200, isCenter: false, section: .left, font: .system(size: 14)),
        .init(title: "Guitar Ensemble", x: 100, y: 360, isCenter: false, section: .left, font: .system(size: 14)),
        .init(title: "ARC @SST", x: 230, y: 120, isCenter: false, section: .left, font: .system(size: 14)),
        .init(title: "Floorball", x: 230, y: 280, isCenter: false, section: .left, font: .system(size: 14)),
        .init(title: "Media Club", x: 230, y: 440, isCenter: false, section: .left, font: .system(size: 14)),
        
        // Middle section - Blue
        .init(title: "Athletics (Track)", x: 360, y: 200, isCenter: false, section: .middle, font: .system(size: 14)),
        .init(title: "Robotics @APEX", x: 360, y: 360, isCenter: false, section: .middle, font: .system(size: 14)),
        .init(title: "Badminton", x: 490, y: 120, isCenter: false, section: .middle, font: .system(size: 14)),
        .init(title: "SST CCA", x: 490, y: 280, isCenter: true, section: .middle, font: .system(size: 25)),
        .init(title: "Scouts", x: 490, y: 440, isCenter: false, section: .middle, font: .system(size: 14)),
        .init(title: "Basketball", x: 620, y: 200, isCenter: false, section: .middle, font: .system(size: 14)),
        .init(title: "Show Choir and Dance", x: 620, y: 360, isCenter: false, section: .middle, font: .system(size: 14)),
        
        // Right section - Grey
        .init(title: "English Drama Club", x: 750, y: 120, isCenter: false, section: .right, font: .system(size: 14)),
        .init(title: "Football", x: 750, y: 280, isCenter: false, section: .right, font: .system(size: 14)),
        .init(title: "SYFC", x: 750, y: 440, isCenter: false, section: .right, font: .system(size: 14)),
        .init(title: "Fencing", x: 880, y: 200, isCenter: false, section: .right, font: .system(size: 14)),
        .init(title: "Taekwondo", x: 880, y: 360, isCenter: false, section: .right, font: .system(size: 14))
    ]
    
    @State private var offsetX: CGFloat = 0.0
    @GestureState private var dragOffset: CGFloat = 0.0
    var body: some View {
        ZStack {
            ForEach(items) { item in
                NavigationLink(destination: CcaDetailView(item: item)) {
                    HexagonView(
                        text: item.title,
                        color: color(for: item.section),
                        font: item.font
                    )
                    .position(x: item.x + offsetX + dragOffset, y: item.y)
                    
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 1000, height: 600)
        .background(Color(NSColor.windowBackgroundColor))
        .clipped()
    }
    
    private func color(for section: HexagonItem.Section) -> Color {
        switch section {
        case .left: return .red
        case .middle: return .blue
        case .right: return .gray
        }
    }
}
#Preview {
    ContentView()
}
