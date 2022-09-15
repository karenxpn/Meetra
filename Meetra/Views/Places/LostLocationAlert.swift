//
//  LostLocationAlert.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI

struct LostLocationAlert: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        VStack( spacing: 30 ){
            Spacer()
            LocationPermission(image: (locationManager.status == "request" && !locationManager.lost_location_socket ) ? "icon_no_location" : "lost_location_icon",
                               title: (locationManager.status == "request" && !locationManager.lost_location_socket ) ? NSLocalizedString("noLocationTitle", comment: "") : NSLocalizedString("lostLocationTitle", comment: ""),
                               content: (locationManager.locationStatus == .notDetermined && !locationManager.lost_location_socket) ? NSLocalizedString("noLocationContent", comment: "") : NSLocalizedString("lostLocationContent", comment: ""))
            Spacer()
            
            Button(action: {
                
                if locationManager.locationStatus == .notDetermined {
                    locationManager.requestLocation()
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
            }

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
