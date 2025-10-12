//
//  EnrichmentView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI

struct Event: Identifiable {
    var name: String
    var date: Date
    var color: Color = Color("lightBlue_1")
    let id = UUID()
}

struct EnrichmentView: View {
    @State var isEnrichmentSheet = false
    @State private var selectedDate: Date = Date()
    @State var newEventName: String = ""
    @State private var editingIndex: Int? = nil
    @State private var events: [Event] = []
    @State private var selectedColor: Color = Color("lightBlue_1")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -70) {
                    ForEach(events.indices, id: \.self) { index in
                        let event = events[index]
                        HStack {
                            if index % 2 == 0 {
                                Spacer(minLength: 30)
                            }

                            EnrichmentHexagonView(enrichmentName: event.name, enrichmentDate: event.date, color: event.color)
                                .scaleEffect(editingIndex == index ? 1.1 : 1.0)
                                .compositingGroup()
                                .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                                .onTapGesture {
                                    editingIndex = index
                                    newEventName = event.name
                                    selectedDate = event.date
                                    isEnrichmentSheet = true
                                }

                            if index % 2 != 0 {
                                Spacer(minLength: 30)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.bottom, -70)
                
                HStack {
                    if events.count % 2 == 0 {
                        Spacer(minLength: 30)
                    }

                    addEventHexagon
                        .padding(.top, -5)
                        .frame(width: 150, height: 160)

                    if events.count % 2 != 0 {
                        Spacer(minLength: 30)
                    }
                }
                .padding(.horizontal, 40)
                .navigationTitle("Enrichment")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        VStack {
                            Text("Keep track of events and competitions here")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                }
                .sheet(isPresented: $isEnrichmentSheet) {
                    eventForm
                }
            }
        }
    }
    
    private var eventForm: some View {
        Form {
            Section {
                TextField("Name", text: $newEventName)
                    .keyboardType(.default)
                DatePicker("Date:", selection: $selectedDate, displayedComponents: .date)
            } header: {
                Text("Event/competition")
            }
            
            Section(header: Text("Color")) {
                ColorPicker("Hexagon Color", selection: $selectedColor)
            }
            
            HStack(alignment: .center) {
                Button(editingIndex != nil ? "Update" : "Add") {
                    guard !newEventName.isEmpty else {
                        return
                    }
                    
                    if let index = editingIndex {
                        events[index].name = newEventName
                        events[index].date = selectedDate
                        events[index].color = selectedColor
                    } else {
                        events.append(Event(name: newEventName, date: selectedDate, color: selectedColor))
                    }
                    events.sort { $0.date < $1.date }
                    resetForm()
                }
                .foregroundStyle(.red)
                
            }
            if editingIndex != nil {
                Button("Delete", role: .destructive) {
                    if let index = editingIndex {
                        events.remove(at: index)
                    }
                    resetForm()
                }
            }
            
            Button("Cancel", role: .cancel) {
                resetForm()
            }
        }
        .presentationDetents([.height(400), .fraction(0.5)])
    }
    
    
    private func resetForm() {
        newEventName = ""
        selectedDate = Date()
        isEnrichmentSheet = false
        editingIndex = nil
    }
    
    private var addEventHexagon: some View {
        ZStack {
            HexagonView()
                .frame(width: 180, height: 190)
                .foregroundStyle(Color("superLightGrey"))
                .compositingGroup()
                .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                .padding()
                .onTapGesture {
                    resetForm()
                    isEnrichmentSheet = true
                }
            Text("+ New")
                .foregroundStyle(.black)
                .font(.system(size: 25))
        }
    }
}

#Preview {
    EnrichmentView()
}
