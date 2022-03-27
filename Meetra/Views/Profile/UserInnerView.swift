//
//  UserInnerView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserInnerView: View {
    let userModel: UserModel
    
    var body: some View {
        ScrollView {
            
//            WebImage(url: URL(string: userModel.images[0]))
//                .placeholder(content: {
//                    ProgressView()
//                })
            Image("user_image_demo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.55)

            VStack( alignment: .leading, spacing: 8) {
                
                HStack() {
                    
                    Text( "\(userModel.name), \(userModel.age)" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 30))
                    
                    if userModel.online {
                        Circle()
                            .fill(AppColors.onlineStatus)
                            .frame(width: 10, height: 10)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image( userModel.starred ? "star" : "star.fill")
                            .resizable()
                            .foregroundColor(AppColors.starColor)
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(.white)
                            .cornerRadius(100)
                            .shadow(radius: 3, x: 0, y: 3)
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Image("user_send_request")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(.white)
                            .cornerRadius(100)
                            .shadow(radius: 3, x: 0, y: 3)
                    })
                }
                
                HStack {
                    
                    if !userModel.school.isEmpty {
                        Image("user_school_icon")
                        Text( userModel.school )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                    
                    if !userModel.location.isEmpty {
                        Image("user_location_icon")
                        Text( userModel.location )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                }
                
                Text(NSLocalizedString("about", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.top)
                
                Text( userModel.bio)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                
                
            }
            .padding(25)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], 34)
            .offset(y: -40)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct UserInnerView_Previews: PreviewProvider {
    static var previews: some View {
        UserInnerView(userModel: AppPreviewModels.userModel)
    }
}
