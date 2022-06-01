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
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var page: Int = 1
    @Published var loadingPage: Bool = false
    @Published var notifications = [NotificationViewModel]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var dataManager: NotificationServiceProtocol
    
    init( dataManager: NotificationServiceProtocol = NotificationService.shared) {
        self.dataManager = dataManager
        super.init()
    }
    
    func getNotifications() {
        if notifications.isEmpty {
            loading = true
        } else {
            loadingPage = true
        }
        dataManager.fetchNotifications(page: page)
            .sink { response in
                self.loading = false
                self.loadingPage = false
                
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.notifications.append(contentsOf: response.value!.notifications.map(NotificationViewModel.init))
                    self.page += 1
                }
            }.store(in: &cancellableSet)
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
                
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                
                DispatchQueue.main.async {
                    self.token = self.initialToken
                }
            }
    }
    
    func checkPermissionStatus(completion: @escaping(UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            DispatchQueue.main.async {
                completion(permission.authorizationStatus)
            }
        }
    }
    
    func makeAlert(with error: NetworkError, message: inout String, alert: inout Bool ) {
        
        if error.initialError.responseCode == 401 {
            self.token = ""
            self.initialToken = ""
            
        } else {
            message = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
            alert.toggle()
        }
    }
}
