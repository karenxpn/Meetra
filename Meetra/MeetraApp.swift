//
//  MeetraApp.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.02.22.
//

import SwiftUI

@main
struct MeetraApp: App {
    
    @AppStorage( "token" ) private var token = ""
    @State private var currentTab: Int = 0
    
    init() {
        let newAppearance = UINavigationBarAppearance()
//        newAppearance.setBackIndicatorImage(UIImage(named: "back")?.withTintColor(UIColor(AppColors.accentColor)), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, .font: UIFont( name: "Inter-Regular", size: 20)!]
        UINavigationBar.appearance().standardAppearance = newAppearance

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.white)
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
