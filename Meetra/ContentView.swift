//
//  ContentView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.02.22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("token") private var token: String = ""
    @State private var currentTab: Int = 0

    var body: some View {
        
//        TabView(selection: $currentTab) {
//            Places()
//                .tabItem {
//                    Image("profiles_icon")
//                        .foregroundColor(.black)
//                }
//
//            Swipes()
//                .tabItem {
//                    Image("profiles_icon")
//                        .foregroundColor(.black)
//
//                }
//
//            Chats()
//                .tabItem {
//                    Image("profiles_icon")
//                        .foregroundColor(.black)
//
//                }
//
//            Profile()
//                .tabItem {
//                    Image("profiles_icon")
//                        .foregroundColor(.black)
//                    Text( "Profile" )
//                        .foregroundColor(.black)
//                }
//        }
        ZStack( alignment: .bottom) {

            VStack {

                if currentTab == 0 {
                    Places()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 1 {
                    Swipes()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 2 {
                    Chats()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 3 {
                    Profile()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }

            CustomTabBar( currentTab: $currentTab )

        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
