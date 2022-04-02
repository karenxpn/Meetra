//
//  CustomTabBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI


struct CustomTabBar: View {
    @Binding var currentTab: Int
    @State private var tab: Bool = true
    let icons = ["place_icon", "profiles_icon", "chat_icon", "account_icon"]
    
    var body: some View {
        Group {
            if tab {
                ZStack {
                    
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(35, corners: [.topLeft, .topRight])
                        .shadow(radius: 2)

                    HStack {
                        
                        ForEach ( 0..<icons.count, id: \.self ) { id in
                            
                            Spacer()
                            Image(icons[id])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(id == currentTab ? AppColors.accentColor : .black)
                                .frame(width: 28, height: 28)
                                .padding(10)
                                .onTapGesture {
                                    withAnimation {
                                        currentTab = id
                                    }
                                }
                            Spacer()
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.1)
            } else {
                EmptyView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "hideTabBar"))) { _ in
            tab = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "showTabBar"))) { _ in
            withAnimation {
                tab = true
            }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(currentTab: .constant( 0 ))
    }
}
