//
//  SwipeCards.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI
import FirebaseAnalytics

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
        .onAppear {
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: "\(SwipeCards.self)",
                                           AnalyticsParameterScreenClass: "\(SwipeCards.self)"])
        }
    }
}

struct SwipeCards_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCards()
    }
}
