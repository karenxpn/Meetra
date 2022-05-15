//
//  ChatListCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.04.22.
//

import SwiftUI

struct ChatListCell: View {
    
    @AppStorage("userId") private var userID: Int = 0
    @State private var navigate: Bool = false
    let chat: ChatModelViewModel
    
    var body: some View {
        
        Button {
            navigate.toggle()
        } label: {
            HStack( alignment: .top, spacing: 14 ) {
                
                ZStack(alignment: .bottomTrailing ) {
                    
                    ImageHelper(image: chat.image, contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                    
                    if chat.online {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 15, height: 15)
                            
                            Circle()
                                .fill(AppColors.onlineStatus)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 4 ) {
                    
                    HStack {
                        Text( chat.name )
                            .kerning(0.28)
                            .foregroundColor(.black)
                            .font(.custom("Inter-SemiBold", size: 14))
                        
                        if chat.mute {
                            Image("mute_icon")
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            if chat.message.sender.id == userID {
                                Image(chat.message.status == "sent" ? "sent_icon" : "read_icon")
                                    .foregroundColor(AppColors.accentColor)
                            }
                            Text(chat.sentTime)
                                .foregroundColor(.gray)
                                .font(.custom("Inter-Regular", size: 12))
                                .kerning(0.24)
                        }
                    }
                    
                    if chat.isGroup {
                        Text( chat.message.sender.name )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                            .kerning(0.24)
                            .lineLimit(1)
                    }
                    
                    Text( ( chat.message.type == "text" ||
                            chat.message.type == "emoji" ) ?
                          chat.message.message :
                            NSLocalizedString("mediaSent", comment: "") )
                    
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 12))
                    .kerning(0.24)
                    .lineLimit(2)
                    
                }.frame(width: .greedy)
            }.frame(width: .greedy)
                .padding(.horizontal, 26)
                .padding(.vertical, 12)
                .background( (chat.message.sender.id != userID && chat.message.status != "read") ?
                             AppColors.addProfileImageBG : Color.white )
        }.buttonStyle(PlainButtonStyle())
            .background(
                NavigationLink(destination: ChatRoom(group: chat.isGroup,
                                                     online: chat.online,
                                                     chatName: chat.name, userID: chat.message.sender.id,
                                                     chatID: chat.id),
                               isActive: $navigate,
                               label: {
                                   EmptyView()
                               }).hidden()
            )
    }
}

struct ChatListCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatListCell(chat: AppPreviewModels.chats[2])
    }
}
