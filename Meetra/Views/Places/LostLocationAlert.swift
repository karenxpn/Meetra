//
//  LostLocationAlert.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI

struct LostLocationAlert: View {
    @State private var settings: Bool = false
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack( spacing: 30 ){
            Spacer()
            LocationPermission(image: (locationManager.status == "request" && locationManager.regionState != .inside ) ? "icon_no_location" : "lost_location_icon",
                               title: (locationManager.status == "request" && locationManager.regionState != .inside ) ? NSLocalizedString("noLocationTitle", comment: "") : NSLocalizedString("lostLocationTitle", comment: ""),
                               content: (locationManager.locationStatus == .notDetermined && locationManager.regionState != .inside) ? NSLocalizedString("noLocationContent", comment: "") : NSLocalizedString("lostLocationContent", comment: ""))
            Spacer()
            
            Button(action: {
                
                if locationManager.locationStatus == .notDetermined {
                    locationManager.requestLocation()
                } else {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    settings.toggle()
                }
            }) {
                
                HStack {
                    Spacer()
                    
                    Text( locationManager.status == "request" ?
                          NSLocalizedString("proceed", comment: "") :
                            NSLocalizedString("check", comment: "") )
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .cornerRadius(30)
            }.background(
                NavigationLink(destination: GeneralSettings(), isActive: $settings, label: {
                    EmptyView()
                }).hidden()
            )

        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).padding(30)
            .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
    }
}

struct LostLocationAlert_Previews: PreviewProvider {
    static var previews: some View {
        LostLocationAlert()
    }
}
