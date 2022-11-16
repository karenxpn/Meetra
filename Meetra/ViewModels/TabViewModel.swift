//
//  TabViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @AppStorage("userId") private var userID: Int = 0
    
    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = false
    @Published var notification: PushNotificationModel?
    @Published var notificationOffset: CGFloat = -UIScreen.main.bounds.height
    
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.socketManager = socketManager
        
        getUnreadMessageResponse()
        getNotification()
    }
    
    func getUnreadMessageResponse() {
        socketManager.fetchTabViewUnreadMessage(userID: userID) { response in
            self.hasUnreadMessage = response
        }
    }
    
    func getNotification() {
        socketManager.fetchNotification(userID: userID) { response in
            self.notification = response
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            self.notificationOffset = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.notification = nil
                self.notificationOffset = -UIScreen.main.bounds.height
                
            })
        }
    }
}
