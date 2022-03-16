//
//  NotificationsViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import Foundation
import UIKit
import Combine
import SwiftUI
import UserNotifications
class NotificationsViewModel: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    @AppStorage("token") private var token: String = ""
    @AppStorage( "initialToken" ) private var initialToken: String = ""
    @Published var deviceToken: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var dataManager: DeviceTokenManager
    
    init( dataManager: DeviceTokenManager = DeviceTokenManager.shared) {
        self.dataManager = dataManager
        super.init()
    }
    
    func sendDeviceToken() {
        dataManager.sendDeviceToken(token: initialToken, deviceToken: deviceToken)
            .sink { (_) in
            } receiveValue: { (_) in
            }.store(in: &cancellableSet)
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                self.token = self.initialToken
                
                if let error = error {
                    print(error)
                } else if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
}
