//
//  Interlocutors.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct Interlocutors: View {
    
    let interlocutors: [InterlocutorsViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack( spacing: 14 ) {
                ForEach( interlocutors, id: \.id ) { interlocutor in
                    InterlocutorsCell(interlocutor: interlocutor)
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
