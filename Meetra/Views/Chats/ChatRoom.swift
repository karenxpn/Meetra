//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatRoom: View {
    
    @StateObject var roomVM: ChatRoomViewModel
    let online: Bool
    let chatName: String
    
    init(online: Bool, userID: Int, chatID: Int, chatName: String) {
        _roomVM = StateObject(wrappedValue: ChatRoomViewModel(chatID: chatID, userID: userID))
        self.online = online
        self.chatName = chatName
    }
    
    var body: some View {
        
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
        }.onAppear {
            roomVM.online = online
        }.alert(isPresented: $roomVM.showAlert, content: {
            Alert(title: Text( "Error" ), message: Text(roomVM.alertMessage), dismissButton: .default(Text("Got It!")))
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: VStack( alignment: .leading) {
            Text( chatName )
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 24))
                .kerning(0.56)
                .lineLimit(1)
            
            // content should be here either group content or just online
            Text( "\(roomVM.online ? NSLocalizedString("nowOnline", comment: "") : "Была 15 минут назад")" )
                .foregroundColor(.gray)
                .font(.custom("Inter-Regular", size: 12))
                .kerning(0.24)
                .lineLimit(1)
            
        }, center: EmptyView(), trailing: Image("dots").foregroundColor(.black))
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(online: true, userID: 1, chatID: 1, chatName: "Hunt Lounge Bar")
    }
}
