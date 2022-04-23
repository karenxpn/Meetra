//
//  EditProfileImageBox.swift
//  Meetra
//
//  Created by Karen Mirakyan on 09.04.22.
//

import SwiftUI

struct EditProfileImageBox: View {
    @Binding var images: [ProfileImageModel]
    @Binding var showPicker: Bool
    let height: CGFloat
    let width: CGFloat
    let index: Int
    let deleteAction: (() -> Void)
    
    var body: some View {
        if images.count > index {
            ZStack( alignment: .bottomLeading) {
                
                ZStack( alignment: .topTrailing) {
                    
                    if images[index].image.hasPrefix("https://") {
                        ImageHelper(image: images[index].image, contentMode: .fill)
                            .frame(width: width,
                                   height: height)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        Image(base64String: images[index].image)?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width,
                                   height: height)
                            .clipped()
                            .cornerRadius(10)
                    }
                    
                    
                    Button {
                        if images[index].image.hasPrefix("https://") {
                            deleteAction()
                        } else {
                            images.remove(at: index)
                        }
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
