//
//  SwipeCards.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct SwipeCards: View {
    @EnvironmentObject var placesVM: PlacesViewModel
    
    var body: some View {
        ZStack( alignment: .top) {
            ForEach(placesVM.users) { user in
                SingleSwipeUser(user: user)
                    .environmentObject(placesVM)
            }
        }.frame(minWidth: 0,
                maxWidth: .infinity)
    }
}

struct SwipeCards_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCards()
    }
}
