//
//  TextMessageContent.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.05.22.
//

import SwiftUI

struct TextMessageContent: View {
    @AppStorage("userId") private var userID: Int = 0
    let message: MessageViewModel
    let group: Bool
    
    var body: some View {
        
        if message.content.isSingleEmoji {
            Text(message.content)
                .font(.system(size: 102))
        } else {
            VStack( alignment: message.sender.id == userID && message.reptyedTo == nil ? .trailing : .leading) {
                
                if group && message.sender.id != userID {
                    Text( message.sender.name )
                        .foregroundColor(AppColors.proceedButtonColor)
                        .font(.custom("Inter-SemiBold", size: 12))
                        .kerning(0.12)
                        .lineLimit(1)
                }
                
                if message.reptyedTo != nil {
                    ReplyedToMessagePreview(senderID: message.sender.id, repliedTo: message.reptyedTo!)
                }
                
                Text(message.content)
                    .foregroundColor(message.sender.id == userID ? .white : .black)
                    .font(.custom("Inter-Regular", size: 12))
                    .kerning(0.24)
                    
            }.padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(message.sender.id == userID ? AppColors.accentColor : AppColors.addProfileImageBG)
                .cornerRadius(message.sender.id == userID ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight], 20)
        }
    }
}

struct TextMessageContent_Previews: PreviewProvider {
    static var previews: some View {
        TextMessageContent(message: AppPreviewModels.message, group: false)
    }
}
