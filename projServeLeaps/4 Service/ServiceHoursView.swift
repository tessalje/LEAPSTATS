
//  ServiceView.swift
//  projServe
//
//  Created by Tessa on 28/4/25.
//  Created by Xi yue Gong on 17/4/25


import SwiftUI

struct ServiceHoursView: View {
    @EnvironmentObject var service: ServiceData
    @State private var showSheet = false
    @State private var event_name: String = ""
    @State private var editingIndex: Int? = nil
    @State private var pdfURL: URL?
    @State var hours = 1
    @State private var selectedService = "Others"
    @State private var previousServiceType = "Others"
    @State private var isProcessing = false // Add loading state

    var serviceType = [
        "Others",
        "VIA for school/community",
        "SIP for school/community"
    ]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        VStack(spacing: -70) {
                            ForEach(service.hexes.indices, id: \.self) { index in
                                let event = service.hexes[index]

                                HStack {
                                    if index % 2 == 0 {
                                        Spacer(minLength: 10)
                                    }

                                    EventHexagonView(eventName: event.name, eventHours: event.hours)
                                        .scaleEffect(editingIndex == index ? 1.1 : 1.0)
                                        .foregroundStyle(event.hours < 3 ? Color("lightBlue_1") : Color("darkerBlue_1"))
                                        .compositingGroup()
                                        .shadow(color: Color("lightGrey_2").opacity(1), radius: 5, x: 0, y: 10)
                                        .onTapGesture {
                                            event_name = event.name
                                            hours = event.hours
                                            selectedService = event.type
                                            previousServiceType = event.type
                                            editingIndex = index
                                            showSheet = true
                                        }
                                        .contextMenu {
                                            Button("Remove", role: .destructive) {
                                                service.removeServiceEvent(at: index)
                                            }
                                        }
                                    
                                    if index % 2 != 0 {
                                        Spacer(minLength: 10)
                                    }
                                }
                                .padding(.horizontal, 40)
                            }

                            HStack {
                                if service.hexes.count % 2 == 0 {
                                    Spacer(minLength: 30)
                                }

                                addEventHexagon
                                    .padding(.top, -5)
                                    .frame(width: 150, height: 160)

                                if service.hexes.count % 2 != 0 {
                                    Spacer(minLength: 30)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
            .navigationTitle("Service")
            .padding()
            .sheet(isPresented: $showSheet) {
                ServiceEditSheet(
                    event_name: $event_name,
                    hours: $hours,
                    selectedService: $selectedService,
                    editingIndex: $editingIndex,
                    isProcessing: $isProcessing,
                    showSheet: $showSheet
                )
                .environmentObject(service)
            }

        }
    }

    private func resetForm() {
        event_name = ""
        hours = 0
        editingIndex = nil
        selectedService = "Others"
        showSheet = false
        isProcessing = false
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
                    editingIndex = nil
                    event_name = ""
                    hours = 0
                    selectedService = "Others"
                    showSheet = true
                }
            Text("+ New")
                .foregroundStyle(.black)
                .font(.system(size: 25))
        }
    }
}

#Preview{
    ServiceHoursView()
        .environmentObject(ServiceData())
}


struct ServiceEditSheet: View {
    @EnvironmentObject var service: ServiceData
    @Environment(\.dismiss) var dismiss
    
    @Binding var event_name: String
    @Binding var hours: Int
    @Binding var selectedService: String
    @Binding var editingIndex: Int?
    @Binding var isProcessing: Bool
    @Binding var showSheet: Bool
    
    var serviceType = [
        "Others",
        "VIA for school/community",
        "SIP for school/community"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Event Name:", text: $event_name)
                        .keyboardType(.default)
                    
                    Stepper(value: $hours, in: 1...100, step: 1) {
                        Text("\(hours) hour\(hours == 1 ? "" : "s")")
                    }
                } header: {
                    Text("Service project")
                }
                
                Section {
                    Picker("Service type:", selection: $selectedService) {
                        ForEach(serviceType, id: \.self) {
                            Text($0)
                        }
                    }
                } header: {
                    Text("Type")
                }
                
                Section {
                    Button(editingIndex != nil ? "Update" : "Add") {
                        guard !event_name.isEmpty, !isProcessing else { return }
                        isProcessing = true
                        
                        if let index = editingIndex {
                            service.updateServiceEvent(at: index, name: event_name, hours: hours, type: selectedService) { success in
                                DispatchQueue.main.async {
                                    isProcessing = false
                                    if success {
                                        dismissSheet()
                                    } else {
                                        print("Failed to update service event")
                                    }
                                }
                            }
                        } else {
                            service.addServiceEvent(name: event_name, hours: hours, type: selectedService) { success in
                                DispatchQueue.main.async {
                                    isProcessing = false
                                    if success {
                                        dismissSheet()
                                    } else {
                                        print("Failed to add service event")
                                    }
                                }
                            }
                        }
                    }
                    .disabled(event_name.isEmpty || isProcessing)
                    
                    if let index = editingIndex {
                        Button("Delete", role: .destructive) {
                            guard !isProcessing else { return }
                            isProcessing = true
                            
                            service.removeServiceEvent(at: index) { success in
                                DispatchQueue.main.async {
                                    isProcessing = false
                                    if success {
                                        dismissSheet()
                                    } else {
                                        print("Failed to delete service event")
                                    }
                                }
                            }
                        }
                        .disabled(isProcessing)
                    }
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle(editingIndex != nil ? "Edit Event" : "Add Event")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func dismissSheet() {
        event_name = ""
        hours = 1
        editingIndex = nil
        selectedService = "Others"
        isProcessing = false
        dismiss()
    }
}
