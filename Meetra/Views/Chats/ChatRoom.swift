//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatRoom: View {
    @StateObject var roomVM = ChatRoomViewModel()
    let group: Bool
    let online: Bool
    let chatName: String
    let userID: Int
    let chatID: Int
    
//    init(group: Bool, online: Bool, userID: Int, chatID: Int, chatName: String) {
//        _roomVM = StateObject(wrappedValue: ChatRoomViewModel(chatID: chatID, userID: userID))
//        self.group = group
//        self.online = online
//        self.chatName = chatName
//
//        print("init")
//    }
    
    var body: some View {
        
        ZStack {
            
            if roomVM.newConversation && roomVM.newConversationResponse != nil{
                NewConversation(newConversation: roomVM.newConversationResponse!)
            } else {
                MessagesList(group: group)
                    .environmentObject(roomVM)
            }
            
            VStack {
                Spacer()
                MessageBar()
                    .environmentObject(roomVM)
            }
        }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
                roomVM.online = online
                roomVM.userID = userID
                roomVM.chatID = chatID
                
                if chatID == 0 {
                    roomVM.getChatId()
                } else {
                    roomVM.joinGetMessagesListenEventsOnInit()
                }
            }.onDisappear {
                NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
            }
            .alert(isPresented: $roomVM.showAlert, content: {
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
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("will enter foreground")
                roomVM.joinRoom()
                
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                
            }
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(group: false, online: true, chatName: "Hunt Lounge Bar", userID: 1, chatID: 1)
    }
}
