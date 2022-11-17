//
//  SinglePlacePreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SinglePlacePreview: View {
    
    let user: UserPreviewModel
    @State private var navigate: Bool = false
    
    var body: some View {
        
        Button {
            navigate.toggle()
        } label: {
            VStack {
                
                ZStack( alignment: .bottomTrailing) {
                    ImageHelper(image: user.image, contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    if user.online {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 15, height: 15)
                                .offset(x: -10, y: -10)
                            
                            Circle()
                                .fill(AppColors.onlineStatus)
                                .frame(width: 10, height: 10)
                                .offset(x: -10, y: -10)
                        }
                    }
                }
                
                Text( user.name )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
            }
        }.background(
            NavigationLink(destination: UserView(userID: user.id), isActive: $navigate, label: {
                EmptyView()
            }).hidden()
        )
    }
}

struct SinglePlacePreview_Previews: PreviewProvider {
    static var previews: some View {
        SinglePlacePreview(user: AppPreviewModels.placeRoom.users[0])
    }
}
