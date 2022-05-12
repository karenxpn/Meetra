//
//  ReplyedToMessagePreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 13.05.22.
//

import SwiftUI

struct ReplyedToMessagePreview: View {
    let replyedTo: ReplyedModel
    var body: some View {
        HStack( alignment: .top) {
            Capsule()
                .fill(AppColors.accentColor)
                .frame(width: 3, height: 35)
            
            LazyVStack( alignment: .leading, spacing: 5) {
                Text(replyedTo.senderName)
                    .foregroundColor(AppColors.accentColor)
                    .font(.custom("Inter-SemiBold", size: 12))
                
                
                if replyedTo.type == "text" {
                    Text(replyedTo.message)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                        .lineLimit(1)
                } else if replyedTo.type == "photo" {
                    ImageHelper(image: replyedTo.message, contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipped()
                    
                } else if replyedTo.type == "video" {
                    Text(NSLocalizedString("videoContent", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)

                } else if replyedTo.type == "audio" {
                    Text(NSLocalizedString("audioContent", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                }
                
                Spacer()
            }
            
        }.padding(.top, 15)
            
    }
}

struct ReplyedToMessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ReplyedToMessagePreview(replyedTo: ReplyedModel(messageId: 1, message: "Окей) Ну будем тебя тогда ждать!", senderName: "Karen", type: "text"))
    }
}
