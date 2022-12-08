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
        
    @State private var enter: Bool = false
    
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
                    Places(enter: $enter)
                        .environmentObject(locationManager)
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 1 {
                    Swipes(enter: $enter, hasfriendRequest: tabViewModel.hasFriendRequest, friendRequestCount: tabViewModel.friendRequestCount)
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
            
                PushNotification(notification: tabViewModel.notification)
                    .offset(y: tabViewModel.notificationOffset)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: tabViewModel.notificationOffset)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            if gesture.translation.height < 0 {
                                tabViewModel.notificationOffset = gesture.translation.height
                            }
                        })
                        .onEnded({ gesture in
                            if gesture.translation.height < -40 {
                                tabViewModel.notificationOffset = -UIScreen.main.bounds.height
                                tabViewModel.notification = nil
                            }
                        })
                    )

        }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                ATTrackingManager.requestTrackingAuthorization { _ in
                }
            }
            .onChange(of: networkVM.isConnected) { value in
                if value {
                    AppSocketManager.shared.connectSocket() {
                        NotificationCenter.default.post(name: Notification.Name("network_reconnection_notification"), object: nil)
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
