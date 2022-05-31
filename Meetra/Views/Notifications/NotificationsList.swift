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
        List {
            
            ForEach(notificationsVM.notifications, id: \.id) { notification in
                NotificationCell(notification: notification, action: {
                    if notification.type == "request" {
                        
                    } else {
                        
                    }
                })
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
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
                }.listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            
        }.listStyle(.plain)
            .padding(.top, 1)
            .refreshable {
                notificationsVM.notifications.removeAll(keepingCapacity: false)
                notificationsVM.page = 1
                notificationsVM.getNotifications()
            }
        
    }
}

struct NotificationsList_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsList()
    }
}
