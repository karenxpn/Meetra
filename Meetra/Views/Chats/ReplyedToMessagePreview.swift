//
//  ReplyedToMessagePreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 13.05.22.
//

import SwiftUI

struct ReplyedToMessagePreview: View {
    @AppStorage("userId") private var userID: Int = 0
    let senderID: Int
    let repliedTo: RepliedModel
    
    var body: some View {
        HStack( alignment: .top) {
            Capsule()
                .fill( senderID == userID ? .white : AppColors.accentColor)
                .frame(width: 3, height: 35)
            
            LazyVStack( alignment: .leading, spacing: 5) {
                Text(repliedTo.sender.name)
                    .foregroundColor( senderID == userID ? .white : AppColors.accentColor)
                    .font(.custom("Inter-SemiBold", size: 12))
                
                
                if repliedTo.type == "text" {
                    Text(repliedTo.message)
                        .foregroundColor(senderID == userID ? .white : .black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                        .lineLimit(1)
                    
                } else if repliedTo.type == "photo" {
                    ImageHelper(image: repliedTo.message, contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipped()
                    
                } else if repliedTo.type == "video" {
                    Text(NSLocalizedString("videoContent", comment: ""))
                        .foregroundColor( senderID == userID ? .white : .black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)

                } else if repliedTo.type == "audio" {
                    Text(NSLocalizedString("audioContent", comment: ""))
                        .foregroundColor( senderID == userID ? .white : .black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                }
                
                Spacer()
            }
            
        }
            
    }
}

struct ReplyedToMessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ReplyedToMessagePreview(senderID: 1, repliedTo: RepliedModel(id: 1, message: "Окей) Ну будем тебя тогда ждать!", type: "text", sender: ReplySenderModel(name: "Karen")))
    }
}
