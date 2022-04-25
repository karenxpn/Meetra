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
            ZStack( alignment: .bottomTrailing) {
                ImageHelper(image: interlocuter.image, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
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
        }

    }
}

struct InterlocutorsCell_Previews: PreviewProvider {
    static var previews: some View {
        InterlocutorsCell(interlocuter: AppPreviewModels.interlocutors[0])
    }
}
