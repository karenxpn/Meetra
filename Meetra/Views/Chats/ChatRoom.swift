//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatRoom: View {
    let chatID: Int
    let chatName: String
    
    var body: some View {
        
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
        }.onAppear {
            if chatID == 0 {
                // need to create chat
            } else {
                // get chat messages
                // connect to socket event
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: VStack( alignment: .leading, spacing: 14) {
            Text( chatName )
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .kerning(0.56)
            
            // content should be here either group content or just online
            Text( "11 участников, 6 онлайн" )
                .foregroundColor(.gray)
                .font(.custom("Inter-Regular", size: 12))
                .kerning(0.24)
        }, center: EmptyView(), trailing: Image("dots"))

    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(chatID: 1, chatName: "Hunt Lounge Bar")
    }
}
