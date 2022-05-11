//
//  EditMessage.swift
//  Meetra
//
//  Created by Karen Mirakyan on 12.05.22.
//

import SwiftUI

struct EditMessage: View {
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
                
                Text(message.content)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                    .lineLimit(1)
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
        EditMessage(showEditing: .constant(false), message: AppPreviewModels.message)
    }
}
