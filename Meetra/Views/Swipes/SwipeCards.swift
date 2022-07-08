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
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        if locationManager.status == "true" && !locationManager.lost_location_socket {
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
        } else {
            LostLocationAlert()
                .environmentObject(locationManager)
        }
    }
}

struct SwipeCards_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCards()
    }
}
