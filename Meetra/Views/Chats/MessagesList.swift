//
//  MessagesList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI

struct MessagesList: View {
    
    @EnvironmentObject var roomVM: ChatRoomViewModel
    let group: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { scrollView in
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(roomVM.messages, id: \.id) { message in
                        MessageCell(message: message, group: group)
                            .environmentObject(roomVM)
                            .padding(.bottom, roomVM.messages[0].id == message.id ? UIScreen.main.bounds.size.height * 0.10 : 0)
                            .padding(.bottom, roomVM.messages[0].id == message.id &&
                                     ( roomVM.editingMessage != nil || roomVM.replyMessage != nil ) ? UIScreen.main.bounds.height * 0.1 : 0)
                            .rotationEffect(.radians(3.14))
                            .onAppear {
                                if message.id == roomVM.messages.last?.id && !roomVM.loading {
                                    roomVM.getMessageList(messageID: message.id)
                                }
                            }
                    }
                    
                    if roomVM.loading {
                        ProgressView()
                            .padding()
                            .padding(.top, roomVM.messages.isEmpty ? UIScreen.main.bounds.height * 0.11 : 0)
                    }
                }.padding(.top, 20)
                .onChange(of: roomVM.typing) { (_) in
                    roomVM.sendTyping()
                    if roomVM.typing {
                        withAnimation {
                            scrollView.scrollTo(roomVM.lastMessageID, anchor: .bottom)
                        }
                    }
                }
            }
        }.rotationEffect(.radians(3.14))
        .padding(.top, 1)
        .padding(.bottom, roomVM.message.numberOfLinesForTextEditor(width: 275) > 10 ? 160 : CGFloat(16*roomVM.message.numberOfLinesForTextEditor(width: 275)))
        .onTapGesture{
            self.hideKeyboard()
        }
    }
}

struct MessagesList_Previews: PreviewProvider {
    static var previews: some View {
        MessagesList(group: false)
            .environmentObject(ChatRoomViewModel())
    }
}
