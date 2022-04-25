//
//  Interlocutors.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct Interlocutors: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach( 1...15, id: \.self ) { _ in
                    Image("test_user")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
            }.padding(.horizontal, 26)
        }
    }
}

struct Interlocutors_Previews: PreviewProvider {
    static var previews: some View {
        Interlocutors()
    }
}
