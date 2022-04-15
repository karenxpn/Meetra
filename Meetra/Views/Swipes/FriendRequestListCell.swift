//
//  FriendRequestListCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct FriendRequestListCell: View {
    @EnvironmentObject var userVM: UserViewModel
    let user: FriendRequestModel
    
    var body: some View {
        HStack( alignment: .top, spacing: 20) {
            ImageHelper(image: user.image, contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            VStack( alignment: .leading) {
                Text( "\(user.name), \(user.age)" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Medium", size: 18))
                
                if user.message.isEmpty {
                    HStack {
                        if !user.school.isEmpty {
                            Image("user_school_icon")
                            Text( user.school )
                                .foregroundColor(.black)
                                .font(.custom("Inter-Regular", size: 12))
                        }
                        
                        if !user.location.isEmpty {
                            Image("user_location_icon")
                            Text( user.location )
                                .foregroundColor(.black)
                                .font(.custom("Inter-Regular", size: 12))
                        }
                    }
                } else {
                    Text( user.message )
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(.white)
                        .padding()
                        .background(AppColors.accentColor)
                        .cornerRadius([.topTrailing, .bottomTrailing, .bottomLeading], 20)
                        .lineLimit(2)
                }
            }            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)

            
            VStack {
                Button {
                    userVM.accept_rejectFriendRequest(id: user.id, status: "accepted")
                } label: {
                    Image("user_send_request")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(15)
                        .background(.white)
                        .cornerRadius(100)
                        .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 3)
                }
                
                Button {
                    userVM.accept_rejectFriendRequest(id: user.id, status: "rejected")
                } label: {
                    Image("reject")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(15)
                        .background(.white)
                        .cornerRadius(100)
                        .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 3)
                }
            }
            
        }.padding(20)
            .background(AppColors.addProfileImageBG)
        
    }
}

struct FriendRequestListCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestListCell(user: AppPreviewModels.friendRequestModel)
            .environmentObject(UserViewModel())
    }
}
