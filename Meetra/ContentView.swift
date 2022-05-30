//
//  ContentView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.02.22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("token") private var token: String = ""
    @StateObject private var tabViewModel = TabViewModel()
    @StateObject private var networkVM = NetworkMonitor()
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "content_view_back"), transitionMaskImage: UIImage(named: "content_view_back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, .font: UIFont( name: "Inter-Regular", size: 28)!]
        UINavigationBar.appearance().standardAppearance = newAppearance
    }

    var body: some View {
        ZStack( alignment: .bottom) {

            VStack {

                if tabViewModel.currentTab == 0 {
                    Places()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 1 {
                    Swipes()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 2 {
                    Chats()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 3 {
                    Profile()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }

            CustomTabBar()
                .environmentObject(tabViewModel)

        }.edgesIgnoringSafeArea(.bottom)
            .onChange(of: networkVM.isConnected) { value in
                if value {
                    AppSocketManager.shared.connectSocket() {
                        NotificationCenter.default.post(name: Notification.Name("network_reconnection_notification"), object: nil)
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
