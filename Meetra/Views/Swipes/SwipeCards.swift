//
//  SwipeCards.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct SwipeCards: View {
    @EnvironmentObject var placesVM: PlacesViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        if placesVM.loading ||
            (locationManager.regionState == nil && locationManager.status == "true") {
            Loading()
        } else if locationManager.status == "true" && locationManager.regionState == .inside {
            ZStack( alignment: .top) {
                ForEach(placesVM.users) { user in
                    SingleSwipeUser(user: user)
                        .environmentObject(placesVM)
                }
            }.frame(minWidth: 0,
                    maxWidth: .infinity)
            .onAppear {
                AppAnalytics().logScreenEvent(viewName: "\(SwipeCards.self)")
            }
        } else if locationManager.status == "use" && locationManager.alwaysRequested {
            AlwaysLocationAlert()
                .environmentObject(locationManager)
        } else {
            LostLocationAlert()
                .environmentObject(locationManager)
                .environmentObject(placesVM)
        }
    }
}

struct SwipeCards_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCards()
    }
}
