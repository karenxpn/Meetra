//
//  Notifications.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import SwiftUI

struct Notifications: View {
    @StateObject var notificationsVM = NotificationsViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                if notificationsVM.loading {
                    Loading()
                } else {
                    NotificationsList()
                        .environmentObject(notificationsVM)
                }
            }.onAppear {
                notificationsVM.getNotifications()
            }.navigationBarItems(leading: Text(NSLocalizedString("notifications", comment: ""))
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), center: EmptyView(), trailing: HStack {
                    
                })
        }.navigationViewStyle(.stack)
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
