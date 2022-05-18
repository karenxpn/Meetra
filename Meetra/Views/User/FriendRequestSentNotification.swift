//
//  FriendRequestSentNotification.swift
//  Meetra
//
//  Created by Karen Mirakyan on 29.03.22.
//

import SwiftUI

struct FriendRequestSentNotification: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State private var message: String = ""
    let userID: Int
    
    var body: some View {
        
        VStack {
            
            if userVM.newConversationResponse == nil {
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
                            userVM.getChatID(userID: userID)
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
                
                Spacer()
            }
            
            
            
            if userVM.newConversationResponse != nil {
                VStack( spacing: 12) {
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            userVM.friendRequestSentOffset = -UIScreen.main.bounds.height
                            userVM.newConversationResponse = nil
                        } label: {
                            Image("close_popup")
                        }
                    }
                    
                    HStack {
                        ImageHelper(image: userVM.newConversationResponse!.userImage, contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .offset(x: 10)
                            .zIndex(3)
                        
                        ImageHelper(image: userVM.newConversationResponse!.interlocutorImage, contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .offset(x: -10)
                            .zIndex(2)
                    }
                    
                    Text(NSLocalizedString("makeContact", comment: ""))
                        .font(.custom("Inter-SemiBold", size: 18))
                        .kerning(0.24)
                        .foregroundColor(.black)
                    
                    Text(NSLocalizedString("writeFirstMessage", comment: ""))
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(.gray)
                        .kerning(0.24)
                        .multilineTextAlignment(.center)
                    
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $message)
                            .foregroundColor(Color.black)
                            .font(.custom("Inter-Regular", size: 12))
                            .padding(.leading, 5)
                            .frame(width: 216, height: 80)
                            .background(AppColors.addProfileImageBG)
                            .onAppear {
                                UITextView.appearance().backgroundColor = .clear
                            }.cornerRadius(10)
                        
                        
                        if message.isEmpty {
                            Text(NSLocalizedString("yourFirstMessage", comment: ""))
                                .kerning(0.24)
                                .font(.custom("Inter-Regular", size: 12))
                                .foregroundColor(Color.black)
                                .padding([.top, .leading], 10)
                        }
                    }
                    
                    Button {
                        userVM.sendMessage(message: message)
                    } label: {
                        Text(NSLocalizedString("send", comment: ""))
                            .font(.custom("Inter-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(width: 216, height: 50)
                            .background(AppColors.proceedButtonColor)
                            .opacity(message.isEmpty ? 0.5 : 1)
                            .cornerRadius(30)
                    }
                    
                    
                }.padding(.top, 22)
                    .padding(.bottom, 50)
                    .padding(.horizontal, 40)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 3)
                    .padding(.horizontal, 26)
                
                Spacer()
            }
        }
    }
}

struct FriendRequestSentNotification_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestSentNotification(userID: 1)
    }
}
