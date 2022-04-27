//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatRoom: View {
    let chatID: Int
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                if chatID == 0 {
                    // need to create chat
                } else {
                    // get chat messages
                    // connect to socket event
                }
            }
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(chatID: 1)
    }
}
