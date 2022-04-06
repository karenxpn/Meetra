//
//  ProfileImageBox.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI

struct ProfileImageBox: View {
    @Binding var model: RegistrationRequest
    @Binding var showPicker: Bool
    let height: CGFloat
    let width: CGFloat
    let index: Int
    
    var body: some View {
        
        if model.images.count > index {
            ZStack( alignment: .bottomLeading) {
                
                ZStack( alignment: .topTrailing) {
                    Image(base64String: model.images[index])?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width,
                               height: height)
                        .clipped()
                        .cornerRadius(10)
                    
                    
                    Button {
                        model.images.remove(at: index)
                    } label: {
                        Image("delete_icon")
                            .padding(10)
                            .background(AppColors.proceedButtonColor)
                            .cornerRadius(30)
                            .offset(x: 10, y: -10)
                    }
                }
                
                if index == 0 {
                    Text( NSLocalizedString("profile_image", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Inter-Regular", size: 8))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 7.5)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(4)
                        .padding(6)
                }
            }.frame(width: width, height: height)
        } else {
            Button {
                showPicker.toggle()
            } label: {
                Image("add_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
                    .frame(width: width, height: height)
                    .background(AppColors.addProfileImageBG)
                    .cornerRadius(10)
            }
        }
        
    }
}
