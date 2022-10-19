//
//  NotificationsList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import SwiftUI

struct NotificationsList: View {
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(notificationsVM.notifications, id: \.id) { notification in
                    NotificationCell(notification: notification)
                        .onAppear(perform: {
                        if notification.id == notificationsVM.notifications.last?.id && !notificationsVM.loadingPage {
                            notificationsVM.getNotifications()
                        }
                    })
                }
                
                if notificationsVM.loadingPage {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }.padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
        
    }
}

struct NotificationsList_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsList()
    }
}
