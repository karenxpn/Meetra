//
//  MessagesList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI

struct MessagesList: View {
    
    @EnvironmentObject var roomVM: ChatRoomViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { scrollView in
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(roomVM.messages, id: \.id) { message in
                        Text(message.message)
                            .environmentObject(roomVM)
                            .padding(.bottom, roomVM.messages[0].id == message.id ? UIScreen.main.bounds.size.height * 0.11 : 0)
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
    }
}

struct MessagesList_Previews: PreviewProvider {
    static var previews: some View {
        MessagesList()
    }
}
