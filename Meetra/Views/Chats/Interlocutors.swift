//
//  Interlocutors.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct Interlocutors: View {
    
    @EnvironmentObject var chatVM: ChatViewModel
    let interlocutors: [InterlocutorsViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack( spacing: 14 ) {
                ForEach( interlocutors, id: \.id ) { interlocuter in
                    InterlocutorsCell(interlocuter: interlocuter)
                }
            }.padding(.horizontal, 26)
        }
    }
}

struct Interlocutors_Previews: PreviewProvider {
    static var previews: some View {
        Interlocutors(interlocutors: AppPreviewModels.interlocutors)
    }
}
