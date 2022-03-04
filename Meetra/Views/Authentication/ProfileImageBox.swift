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
        ZStack {
            AppColors.addProfileImageBG
                .cornerRadius(10)
            
            Button {
                showPicker.toggle()
            } label: {
                Group {
                    if model.images.count > index {
                        ZStack {
                            
                            Image(base64String: model.images[index])?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width,
                                       height: height)
                                .clipped()
                                .cornerRadius(30)
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Button {
                                        model.images.remove(at: index)
                                    } label: {
                                        Image("delete_icon")
                                            .padding(10)
                                            .background(AppColors.proceedButtonColor)
                                            .cornerRadius(30)
                                            .offset(x: 10, y: -10)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        Image("add_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                    }
                }
            }
            
        }.frame(width: width, height: height)
    }
}
