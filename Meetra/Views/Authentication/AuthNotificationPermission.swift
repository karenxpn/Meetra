//
//  AuthNotificationPermission.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import SwiftUI

struct AuthNotificationPermission: View {
    var body: some View {
        NotificationPermission(image: "location_icon", title: NSLocalizedString("authLocationRequest", comment: ""), content: NSLocalizedString("authLocationRequestContent", comment: ""))
            .navigationBarItems(trailing: Button(action: {
                
            }, label: {
                Text( "Пропустить")
                    .foregroundColor(AppColors.proceedButtonColor)
                    .font(.custom("Inter-SemiBold", size: 18))
            }))
    }
}

struct AuthNotificationPermission_Previews: PreviewProvider {
    static var previews: some View {
        AuthNotificationPermission()
    }
}


struct NotificationPermission: View {
    let image: String
    let title: String
    let content: String
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 140)
            
            
            Text( title )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
                .multilineTextAlignment(.center)

            
            Text( content )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    
                    Text( "Включить" )
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .cornerRadius(30)
            }

            
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).padding(30)
    }
}
