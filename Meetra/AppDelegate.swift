//
//  AppDelegate.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import SwiftUI
import FirebaseCore
import UserNotifications
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @ObservedObject var notificationsVM = NotificationsViewModel()
    @ObservedObject var locationManager = LocationManager()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        notificationsVM.checkPermissionStatus { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if locationManager.locationStatus == .authorizedAlways {
            print("mi tut")
            locationManager.locationManager.sendRegionState(identifier: "ChIJi6C1MxquEmsR9-c-3O48ykI", state: false).sink { _ in
            }.store(in: &cancellableSet)
            sleep(2)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken
            .map{ String( format: "%02.2hhx", $0)}
            .joined()
        
        notificationsVM.deviceToken = token
        notificationsVM.sendDeviceToken()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let state = application.applicationState
        switch state {
        case .background:
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        default:
            break
        }
        
        //        if let dict = userInfo.first?.value as? [String : Any] {
        //            if let alert = dict["alert"] as? [String : Any] {
        //                if let action = alert["action"] as? String {
        //                    NotificationCenter.default.post(name: Notification.Name("notificationFetched"), object: ["action" : action])
        //                }
        //            }
        //        }
    }
    
//    // foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("foreground")
//        print("\(notification.request.content.userInfo)")
////        completionHandler([[.banner, .badge, .sound]])
//    }
    
    // background // this is called when user taps on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
