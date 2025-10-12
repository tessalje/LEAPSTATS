//
//  ServiceView.swift
//  projServe
//
//  Created by Vijayaganapathy Pavithraa on 26/4/25.
//

import SwiftUI

struct ServiceView: View {
    @EnvironmentObject var service: ServiceData

    var body: some View {
        ServiceFrontPage()
    }
}

#Preview {
    ServiceView()
        .environmentObject(ServiceData())
}
