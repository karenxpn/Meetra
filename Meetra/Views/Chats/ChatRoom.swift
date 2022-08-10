//
//  ChatRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI
import FirebaseAnalytics

struct ChatRoom: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var roomVM = ChatRoomViewModel()
    @State private var showPopup: Bool = false
    let group: Bool
    let online: Bool
    let lastVisit: String
    let chatName: String
    let userID: Int
    let chatID: Int
    let left: Bool
    
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
                if !left {
                    MessageBar()
                        .environmentObject(roomVM)
                } else {
                    Text(NSLocalizedString("youLeftChat", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regualr", size: 14))
                        .kerning(0.24)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.bottom, 30)
                }
            }
        }.ignoresSafeArea(.container, edges: .bottom)
            .onAppear {
                NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
                roomVM.online = online
                roomVM.lastVisit = lastVisit
                roomVM.userID = userID
                roomVM.chatID = chatID
                
                if chatID == 0 {
                    roomVM.getChatId()
                } else {
                    roomVM.joinGetMessagesListenEventsOnInit()
                }
                
                if group {
                    Analytics.logEvent("group_chat", parameters: nil)
                } else {
                    Analytics.logEvent("personal_chat", parameters: nil)
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
                if !group {
                    Text( "\(roomVM.online ? NSLocalizedString("nowOnline", comment: "") : roomVM.lastVisit)" )
                        .foregroundColor(.gray)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                        .lineLimit(1)
                        .fixedSize()
                }
                
            }, center: EmptyView(), trailing: group ? AnyView(Button(action: {
                showPopup.toggle()
            }, label: {
                Image("dots").foregroundColor(.black)
            })) : AnyView(EmptyView()))
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                roomVM.joinGetMessagesListenEventsOnInit()
            }.modifier(NetworkReconnection(action: {
                roomVM.joinGetMessagesListenEventsOnInit()
            })).fullScreenCover(isPresented: $showPopup) {
                CustomActionSheet {
                    
                    ActionSheetButtonHelper(icon: "unread_icon",
                                            label: NSLocalizedString("markUnread", comment: ""),
                                            role: .cancel) {
                        roomVM.markAsUnread()
                        self.showPopup.toggle()
                        
                    }
                    
                    Divider()
                    
                    ActionSheetButtonHelper(icon: "trash_icon",
                                            label: NSLocalizedString("delete", comment: ""),
                                            role: .destructive) {
                        roomVM.deleteChat()
                        self.showPopup.toggle()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    Divider()
                    
                    if !left {
                        ActionSheetButtonHelper(icon: "exit_icon",
                                                label: NSLocalizedString("leaveChat", comment: ""),
                                                role: .destructive) {
                            roomVM.leaveChat()
                            self.showPopup.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(group: false, online: true, lastVisit: "", chatName: "Hunt Lounge Bar", userID: 1, chatID: 1, left: true)
    }
}
