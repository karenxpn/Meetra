//
//  NotificationButton.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import SwiftUI

struct NotificationButton: View {
    @State private var navigate: Bool = false
    
    var body: some View {
        Button {
            navigate.toggle()
        } label: {
            Image("icon_ring")
                .foregroundColor(.black)
        }.background(
            NavigationLink(isActive: $navigate, destination: {
                Notifications()
            }, label: {
                EmptyView()
            }).hidden()
        )
    }
}

struct NotificationButton_Previews: PreviewProvider {
    static var previews: some View {
        NotificationButton()
    }
}
