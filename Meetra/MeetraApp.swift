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
    @AppStorage( "token" ) private var token = ""
    @State private var currentTab: Int = 0
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, .font: UIFont( name: "Inter-Black", size: 28)!]
        UINavigationBar.appearance().standardAppearance = newAppearance

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.black)
    }
    
    var body: some Scene {
        WindowGroup {
            if token == "" {
                GlobalAuth()
            } else {
                ContentView(currentTab: $currentTab)
            }
        }
    }
}
