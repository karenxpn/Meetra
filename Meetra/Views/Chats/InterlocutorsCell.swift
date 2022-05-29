//
//  InterlocutorsCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct InterlocutorsCell: View {
    let interlocutor: InterlocutorsViewModel
    @State private var navigate: Bool = false
    
    var body: some View {
        Button {
            navigate.toggle()
        } label: {
            ZStack( alignment: .trailing) {
                ImageHelper(image: interlocutor.image, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack {
                    
                    if !interlocutor.read {
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
                    if interlocutor.online {
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
            NavigationLink(destination: ChatRoom( group: false,
                                                  online: interlocutor.online,
                                                  lastVisit: interlocutor.lastVisit,
                                                  chatName: interlocutor.name,
                                                  userID: interlocutor.id,
                                                  chatID: interlocutor.chat),
                           isActive: $navigate,
                           label: {
                EmptyView()
            }).hidden()
        )
    }
}

struct InterlocutorsCell_Previews: PreviewProvider {
    static var previews: some View {
        InterlocutorsCell(interlocutor: AppPreviewModels.interlocutors[0])
    }
}
