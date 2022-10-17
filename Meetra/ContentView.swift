//
//  ContentView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.02.22.
//

import SwiftUI
import AppTrackingTransparency

struct ContentView: View {
    @AppStorage("token") private var token: String = ""
    @StateObject private var tabViewModel = TabViewModel()
    @StateObject private var networkVM = NetworkMonitor()
    @StateObject private var locationManager = LocationManager()
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var seconds: Int = 0
    
    
    
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
                        .environmentObject(locationManager)
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 1 {
                    Swipes()
                        .environmentObject(locationManager)
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
            .onAppear {
                print(token)
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                ATTrackingManager.requestTrackingAuthorization { _ in
                }
            }
            .onChange(of: networkVM.isConnected) { value in
                if value {
                    AppSocketManager.shared.connectSocket() {
                        NotificationCenter.default.post(name: Notification.Name("network_reconnection_notification"), object: nil)
                    }
                }
            }.onReceive(timer) { _ in
                seconds += 1
                if seconds % 180 == 0 {
                    if locationManager.status == "true" {
                        locationManager.sendLocation()
                    }
                }
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                // send request for offline
                locationManager.sendOnline(online: false)
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // send request for online
                locationManager.sendOnline(online: true)
             }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
