//
//  TabViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import SwiftUI
import Combine

class TabViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userId") private var userID: Int = 0
    
    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = false
    @Published var unreadMessageCount: Int = 0
    @Published var hasFriendRequest: Bool = false
    @Published var friendRequestCount: Int = 0
    @Published var notification: PushNotificationModel?
    @Published var notificationOffset: CGFloat = -UIScreen.main.bounds.height
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var dataManager: NotificationServiceProtocol
    var socketManager: AppSocketManagerProtocol
    
    init(dataManager: NotificationServiceProtocol = NotificationService.shared,
         socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.socketManager = socketManager
        self.dataManager = dataManager
        super.init()
        
        getUnreadMessageResponse()
        getFriendRequestStat()
        
        getUnreadMessageResponseUpdate()
        getFriendRequestStatUpdate()
        getNotification()
    }
    
    func getUnreadMessageResponse() {
        dataManager.fetchTabViewUnreadMessage(id: userID)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.hasUnreadMessage = response.value!.unreadMessage
                    self.unreadMessageCount = response.value!.unreadMessageCount
                }
            }.store(in: &cancellableSet)
    }
    
    func getUnreadMessageResponseUpdate() {
        socketManager.fetchTabViewUnreadMessage(userID: userID) { response in
            self.hasUnreadMessage = response.unreadMessage
            self.unreadMessageCount = response.unreadMessageCount
        }
    }
    
    func getFriendRequestStat() {
        dataManager.fetchFriendRequestStat(id: userID)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.hasFriendRequest = response.value!.hasFriendRequest
                    self.friendRequestCount = response.value!.friendRequestCount
                }
            }.store(in: &cancellableSet)
    }
    
    func getFriendRequestStatUpdate() {
        socketManager.fetchFriendRequestStat(userID: userID) { response in
            self.hasFriendRequest = response.hasFriendRequest
            self.friendRequestCount = response.friendRequestCount
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
