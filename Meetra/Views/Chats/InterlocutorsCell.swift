//
//  InterlocutorsCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct InterlocutorsCell: View {
    let interlocuter: InterlocutorsViewModel
    var body: some View {
        Button {
            
        } label: {
            ZStack( alignment: .trailing) {
                ImageHelper(image: interlocuter.image, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack {
                    
                    if interlocuter.hasUnreadMessage {
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
        }
    }
}

struct InterlocutorsCell_Previews: PreviewProvider {
    static var previews: some View {
        InterlocutorsCell(interlocuter: AppPreviewModels.interlocutors[0])
    }
}
