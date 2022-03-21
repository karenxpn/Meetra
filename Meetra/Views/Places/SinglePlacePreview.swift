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
    
    var body: some View {
        
        VStack {
            
            ZStack( alignment: .bottomTrailing) {
                Image("Karen")
                //            WebImage(url: URL(string: user.image)!)
                //                .placeholder {
                //                    ProgressView()
                //                }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 95, height: 95)
                    .clipShape(Circle())
                
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 15, height: 15)
                        .offset(x: -5, y: -5)
                    
                    Circle()
                        .fill(AppColors.onlineStatus)
                        .frame(width: 10, height: 10)
                        .offset(x: -5, y: -5)
                }
            }
            
            Text( user.name)
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
        }
    }
}

struct SinglePlacePreview_Previews: PreviewProvider {
    static var previews: some View {
        SinglePlacePreview(user: UserPreviewModel(id: 1, image: "", name: "Karen", online: true))
    }
}
