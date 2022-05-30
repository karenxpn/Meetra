//
//  MeetraApp.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.02.22.
//

import SwiftUI

@main
struct MeetraApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    let appSocketManager = AppSocketManager.shared
    
    @AppStorage( "token" ) private var token = ""
    
    
    var body: some Scene {
        WindowGroup {
            if token == "" {
                GlobalAuth()
            } else {
                ContentView()
            }
        }.onChange(of: phase) { newScene in
            
            switch newScene {
            case .active:
                UIApplication.shared.applicationIconBadgeNumber = 0
            default:
                break
            }
        }.onChange(of: token) { newValue in
            if token.isEmpty {
                appSocketManager.disconnectSocket()
            } else {
                appSocketManager.connectSocket() { }
            }
        }
    }
}
