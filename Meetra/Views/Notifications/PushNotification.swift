//
//  PushNotification.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.11.22.
//

import SwiftUI

struct PushNotification: View {
    let notification: PushNotificationModel?
    
    var body: some View {
        VStack {
            if let notification {
                HStack( spacing: 20 ) {
                    Image("app_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                    VStack( alignment: .leading, spacing: 8 ) {
                        Text( notification.title )
                            .foregroundColor(.black)
                            .font(.custom("Inter-SemiBold", size: 14))
                        
                        Text( notification.content )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                        
                    }
                    
                    Spacer()
                }.frame( minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(radius: 1)
                    .padding()
                    .padding(.top, UIScreen.main.bounds.height * 0.04 )
            }
            

            Spacer()
        }.edgesIgnoringSafeArea(.all)
    }
}

struct PushNotification_Previews: PreviewProvider {
    static var previews: some View {
        PushNotification(notification: PushNotificationModel(title: "New message", content: "Karen Mirakyan sent you a new message"))
    }
}
