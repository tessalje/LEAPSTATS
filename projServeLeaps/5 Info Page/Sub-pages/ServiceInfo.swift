//
//  serviceInfo.swift
//  InfoPage
//
//  Created by Tessa on 8/6/25.
//

import SwiftUI
struct ServiceInfoView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Text("Service hours are for students who contribute to the community. Every student has to contribute at least 6h per year. Students will get hours for planning, service and reflection in a VIA/SIP/SL project.")
                    .padding(10)
                    .frame(width: 380, height: 130)
                    .background(.white.opacity(0.6))
                    .cornerRadius(10)
            GroupBox("HEHHE"){
                Text("HI")
            }
        }
        .navigationTitle("Service")
            
        }
    }
}

let serviceLevels = [
    """
    Level 0:
    - Less than 24 hours
    """,
    """
    Level 1: 
    - 24 to 30 service hours
    """,
    """
    Level 2: 
    - 30 to 36 service hours
    - Completed at least 1 VIA project for the school/community
    """,
    """
    Level 3:
    - At least 36 service hours
    - Completed 2 VIA projects for the school/community
    - 24 service hours and 1 VIA project for the school/community
    """,
    """
    Level 4: 
    - 24 service hours and 2 VIA projects for the school/community
    """,
    """
    Level 5: 
    - 24 hours of service and 1 student-led project for the community and 1 VIA project.
    """
]


#Preview {
    ServiceInfoView()
}
