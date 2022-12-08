//
//  NotificationCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import SwiftUI

struct NotificationCell: View {
    @State private var navigate: Bool = false
    @State private var navigateChat: Bool = false
    @State private var navigateRequests: Bool = false
    let notification: NotificationViewModel
    
    var body: some View {
        HStack( alignment: .center, spacing: 16) {
            
            ImageHelper(image: notification.user.image, contentMode: .fill)
                .frame(width: 53, height: 53)
                .clipShape(Circle())
            
            Button {
                navigate.toggle()
            } label: {
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
                
            }.background(
                NavigationLink(destination: UserView(userID: notification.user.id), isActive: $navigate, label: {
                    EmptyView()
                }).hidden()
            )
            
            Button {
                if notification.type == "friend-request" {
                    navigateRequests.toggle()
                } else {
                    navigateChat.toggle()
                }
            } label: {
                Text( notification.type == "friend-request" ? NSLocalizedString("view", comment: "") : NSLocalizedString("reply", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Inter-SemiBold", size: 12))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 18)
                    .background(AppColors.accentColor)
                    .cornerRadius(10)
            }.background(
                ZStack {
                    if notification.chat != nil {
                        NavigationLink(destination: ChatRoom(group: false,
                                                             online: notification.user.online,
                                                             lastVisit: notification.lastVisit,
                                                             chatName: notification.user.name,
                                                             chatImage: notification.user.image,
                                                             userID: notification.user.id,
                                                             chatID: notification.chat!, left: false,
                                                             blocked: notification.blocked,
                                                             blockedByMe: notification.blockedByMe), isActive: $navigateChat) {
                            EmptyView()
                        }.hidden()
                    } else {
                        NavigationLink(destination: FriendRequestList(), isActive: $navigateRequests) {
                            EmptyView()
                        }.hidden()
                    }
                }
            )
            
        }.frame(width: .greedy)
            .padding(.horizontal, 26)
            .padding(.vertical, 10)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell(notification: AppPreviewModels.notifications[0])
    }
}
