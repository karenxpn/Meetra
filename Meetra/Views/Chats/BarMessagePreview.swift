//
//  EditMessage.swift
//  Meetra
//
//  Created by Karen Mirakyan on 12.05.22.
//

import SwiftUI

struct BarMessagePreview: View {
    @Binding var showEditing: Bool
    let message: MessageViewModel

    var body: some View {
        
        HStack( alignment: .top) {
            Capsule()
                .fill(AppColors.accentColor)
                .frame(width: 3, height: 35)
            
            VStack( alignment: .leading) {
                Text(message.sender.name)
                    .foregroundColor(AppColors.accentColor)
                    .font(.custom("Inter-SemiBold", size: 12))
                
                
                if message.type == "text" {
                    Text(message.content)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                        .lineLimit(1)
                } else if message.type == "photo" {
                    ImageHelper(image: message.content, contentMode: .fit)
                        .frame(width: 30, height: 30)
                    
                } else if message.type == "video" {
                    Text(NSLocalizedString("videoContent", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)

                } else if message.type == "audio" {
                    Text(NSLocalizedString("audioContent", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .kerning(0.24)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    showEditing = false
                }
            } label: {
                Image("close_icon")
            }
        }.padding(.horizontal, 20)
            .padding(.top, 15)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], 35)
            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
    }
}

struct EditMessage_Previews: PreviewProvider {
    static var previews: some View {
        BarMessagePreview(showEditing: .constant(false), message: AppPreviewModels.message)
    }
}
