//
//  FriendRequestSentNotification.swift
//  Meetra
//
//  Created by Karen Mirakyan on 29.03.22.
//

import SwiftUI

struct FriendRequestSentNotification: View {

    var body: some View {
        
        VStack( alignment: .leading, spacing: 8 ) {
            Text( NSLocalizedString("friendRequestSent", comment: "") )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 14))
            
            Text( NSLocalizedString("youCanSendMessage", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 12))
            
            HStack {
                Spacer()
                
                Button {
                    // open dialogue 
                } label: {
                    Text(NSLocalizedString("send", comment: ""))
                        .foregroundColor(AppColors.proceedButtonColor)
                        .font(.custom("Inter-SemiBold", size: 12))
                }

                
            }
        }.frame( minWidth: 0, maxWidth: .infinity)
        
            .padding()
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 1)
            .padding()
    }
}

struct FriendRequestSentNotification_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestSentNotification()
    }
}
