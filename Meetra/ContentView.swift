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
        ZStack( alignment: .bottom) {
            
            VStack {
                
                if currentTab == 0 {
                    Places()
//                    Button{
//                        token = ""
//                    } label: {
//                        Text( "Sign out" )
//                    }
//                        .font(.custom("Inter-Regular", size: 20))

                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 1 {
//                    Reports()
                    Text( "Second" )
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 2 {
//                    Search()
                    Text( "Third" )
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if currentTab == 3 {
//                    Chat()
                    Text( "Fourth" )
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
