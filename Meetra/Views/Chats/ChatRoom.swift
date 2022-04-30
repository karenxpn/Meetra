//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatRoom: View {
    
    @StateObject var roomVM = ChatRoomViewModel()
    let userID: Int
    let chatID: Int
    let chatName: String
    
    var body: some View {
        
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
        }.onAppear {
            if chatID == 0 {
                roomVM.getChatId(userID: userID)
                // need to create chat
            } else {
                roomVM.chatId = chatID
                roomVM.joinRoom()
                roomVM.getTypingResponse()
                roomVM.getOnlineStatus(userID: userID)
            
                // get chat messages
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: VStack( alignment: .leading) {
            Text( chatName )
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 24))
                .kerning(0.56)
                .lineLimit(1)
            
            // content should be here either group content or just online
            Text( "11 участников, 6 онлайн" )
                .foregroundColor(.gray)
                .font(.custom("Inter-Regular", size: 12))
                .kerning(0.24)
                .lineLimit(1)
            
        }, center: EmptyView(), trailing: Image("dots").foregroundColor(.black))
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(userID: 1, chatID: 1, chatName: "Hunt Lounge Bar")
    }
}
