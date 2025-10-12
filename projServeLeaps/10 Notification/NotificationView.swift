//
//  ContentView.swift
//  notifications
//
//  Created by Tessa on 21/7/25.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: notificationManager.isAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(notificationManager.isAuthorized ? .green : .red)
                    Text("Notifications \(notificationManager.isAuthorized ? "Enabled" : "Disabled")")
                        .font(.headline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                if !notificationManager.isAuthorized {
                    Button("Enable Notifications") {
                        notificationManager.requestPermission()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button("Send Notifications") {
                    notificationManager.allTermlyNotifications()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!notificationManager.isAuthorized)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Notification History")
                            .font(.headline)
                        Spacer()
                        Text("\(notificationManager.notifications.count) total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if notificationManager.notifications.isEmpty {
                        Text("No notifications yet")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 40)
                    } else {
                        List(notificationManager.notifications) { notification in
                            NotificationRowView(notification: notification)
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 300) // Limit height so buttons aren't pushed off screen
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Notification Manager")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct NotificationRowView: View {
    let notification: NotificationRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(notification.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: notification.isDelivered ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(notification.isDelivered ? .green : .red)
                        .font(.caption)
                    
                    Text(notification.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(notification.body)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotificationView()
}
