//
//  NotificationCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import SwiftUI

struct NotificationCell: View {
    let notification: NotificationViewModel
    let action: (() -> Void)
    
    var body: some View {
        HStack( alignment: .center, spacing: 16) {
            
            ImageHelper(image: notification.user.image, contentMode: .fill)
                .frame(width: 53, height: 53)
                .clipShape(Circle())
            
            LazyVStack(alignment: .leading, spacing: 4) {
                Text( "\(notification.user.name), \(notification.user.age)" )
                    .foregroundColor(AppColors.accentColor)
                    .font(.custom("Inter-Regular", size: 12))
                    .lineLimit(1)
                
                if notification.type == "send-message" {
                    Text( NSLocalizedString("wrote", comment: "") )
                        .kerning(0.24)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12)) +
                    Text( "message" )
                        .kerning(0.24)
                        .foregroundColor(AppColors.accentColor)
                        .font(.custom("Inter-Regular", size: 12))
                } else if notification.type == "message-reaction" {
                    Text( NSLocalizedString("left", comment: "") )
                        .kerning(0.24)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12)) +
                    Text( "reactedToMessage" )
                        .kerning(0.24)
                        .foregroundColor(AppColors.accentColor)
                        .font(.custom("Inter-Regular", size: 12))
                } else {
                    Text( NSLocalizedString("sent", comment: "") )
                        .kerning(0.24)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12)) +
                    Text( "friendRequest" )
                        .kerning(0.24)
                        .foregroundColor(AppColors.accentColor)
                        .font(.custom("Inter-Regular", size: 12))
                }
                
                Text( notification.createdAt == NSLocalizedString("nowOnline", comment: "") ? NSLocalizedString("now", comment: "") : notification.createdAt )
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 12))
            }.frame(width: .greedy)
                        
            Button {
                action()
                
            } label: {
                Text( notification.type == "request" ? NSLocalizedString("view", comment: "") : NSLocalizedString("reply", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Inter-SemiBold", size: 12))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 18)
                    .background(AppColors.accentColor)
                    .cornerRadius(10)
            }

            
        }.frame(width: .greedy)
        .padding(.horizontal, 26)
            .padding(.vertical, 10)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell(notification: AppPreviewModels.notifications[0]) {
            
        }
    }
}
