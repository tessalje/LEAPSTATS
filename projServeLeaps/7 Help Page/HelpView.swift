//
//  NyaaView.swift
//  projServeLeaps
//
//  Created by Tessa on 26/6/25.
//

import SwiftUI
import MessageUI

struct HelpView: View {
    var body: some View {
        NavigationStack{
            List {
                    Section {
                        NavigationLink("Help (tutorial)", destination: TutorialView())
                            .font(.title3)
                    } header: {
                        Text("About the app")
                    }
                    
                    Section {
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Tessa Lee Jin En")
                                    .font(.title3)
                                Text("Chief Executive Officer")
                                    .foregroundStyle(Color(.gray))
                            }
                            Spacer()
                            
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Vijayaganapathy Pavithraa")
                                    .font(.title3)
                                Text("Chief Operating Officer")
                                    .foregroundStyle(Color(.gray))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "person.2.badge.gearshape.fill")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Gong Xi Yue")
                                    .font(.title3)
                                Text("Chief Design Officer")
                                    .foregroundStyle(Color(.gray))
                            }
                            Spacer()
                            
                            Image(systemName: "paintbrush.pointed.fill")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Balasaravanan Dhanwin Basil")
                                    .font(.title3)
                                Text("Chief Technology Officer (Android)")
                                    .foregroundStyle(Color(.gray))
                            }
                            Spacer()
                            
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Kesler Ang Kang Zhi")
                                    .font(.title3)
                                Text("Chief Technology Officer (iOS)")
                                    .foregroundStyle(Color(.gray))
                            }
                            Spacer()
                            
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 2){
                                Text("Mr Ng Jun Wei")
                                    .font(.title3)
                                Text("Client")
                                    .foregroundStyle(Color(.gray))
                            }
                            Spacer()
                            
                            Image(systemName: "person")
                                .font(.title)
                                .foregroundStyle(Color(.darkBlue1))
                            
                        }
                    } header: {
                        Text("Acknowledgements")
                    }
                    
                Link(destination: URL(string: "https://mail.google.com/mail/?view=cm&fs=1&to=codexleaps2.0@gmail.com&su=Feedback&body=Hi%20CodeX,"
                    )!
                ) {
                    Label("Send as a feedback: codexleaps2.0@gmail.com", systemImage: "envelope.fill")
                }
                
            }
            .navigationTitle("Others")
        }
    }
}

struct MailComposerViewController: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipients: [String]
    var subject: String
    var messageBody: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        return mailComposer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposerViewController

        init(_ parent: MailComposerViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}

#Preview {
    HelpView()
}
