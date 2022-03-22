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
    
    @AppStorage( "token" ) private var token = ""
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, .font: UIFont( name: "Inter-Regular", size: 28)!]
        UINavigationBar.appearance().standardAppearance = newAppearance
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.black)
    }
    
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
        }
    }
}
