//
//  InterlocutorsCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct InterlocutorsCell: View {
    let interlocuter: InterlocutorsViewModel
    @State private var navigate: Bool = false
    
    var body: some View {
        Button {
            navigate.toggle()
        } label: {
            ZStack( alignment: .trailing) {
                ImageHelper(image: interlocuter.image, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack {
                    
                    if !interlocuter.read {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 15, height: 15)
                            
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    if interlocuter.online {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 15, height: 15)
                            
                            Circle()
                                .fill(AppColors.onlineStatus)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                

            }.frame(width: 60, height: 60)
        }.background(
            NavigationLink(destination: ChatRoom(chatID: interlocuter.id, chatName: interlocuter.name),
                           isActive: $navigate,
                           label: {
                EmptyView()
            }).hidden()
        )
    }
}

struct InterlocutorsCell_Previews: PreviewProvider {
    static var previews: some View {
        InterlocutorsCell(interlocuter: AppPreviewModels.interlocutors[0])
    }
}
