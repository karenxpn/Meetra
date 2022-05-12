//
//  NewConversation.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.05.22.
//

import SwiftUI

struct NewConversation: View {
    let newConversation: NewConversationResponse
    var body: some View {
        
        VStack( spacing: 14) {
            HStack(spacing: 0) {
                ImageHelper(image: newConversation.userImage, contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .offset(x: 10)
                    .zIndex(3)
                
                ImageHelper(image: newConversation.interlocutorImage, contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .offset(x: -10)
                    .zIndex(2)
                
                if newConversation.groupMembers != 2 {
                    Text("+\(newConversation.groupMembers - 2)")
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 20))
                        .kerning(0.24)
                        .frame(width: 100, height: 100)
                        .background(AppColors.addProfileImageBG)
                        .clipShape(Circle())
                        .offset(x: -30)
                        .zIndex(1)
                }
            }.padding(.bottom, 12)
                .padding(.leading, 10)
            
            Text(NSLocalizedString("foundInterlocutor", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
                .kerning(0.18)
            
            Text( NSLocalizedString("writeFirstMessage", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 12))
                .kerning(0.24)
                .multilineTextAlignment(.center)
            
        }.fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
    }
}

struct NewConversation_Previews: PreviewProvider {
    static var previews: some View {
        NewConversation(newConversation: AppPreviewModels.newConversation)
    }
}
