//
//  appInfoView.swift
//  projServeLeaps
//
//  Created by Pavithraa Vijayaganapathy on 12/11/25.
//

import SwiftUI

struct appInfoView: View {
    var body: some View {
        NavigationStack{
            List {
                
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
                            Text("Xiyue Gong")
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
                    Label("Send feedback at codexleaps2.0@gmail.com", systemImage: "envelope.fill")
                }
                
            }
            .navigationTitle("App Info")
        }
    }
}

#Preview {
    appInfoView()
}
