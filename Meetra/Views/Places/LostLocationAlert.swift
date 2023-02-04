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
    @EnvironmentObject var placesVM: PlacesViewModel
    
    var body: some View {
        VStack( spacing: 30 ){
            Spacer()
            if locationManager.locationStatus == .authorizedWhenInUse {
                LocationPermission(image:  "lost_location_icon",
                                   title: NSLocalizedString("noLocationAlwaysTitle", comment: ""),
                                   content: NSLocalizedString("locationAlwaysRequest", comment: ""))
            } else if locationManager.locationStatus == .authorizedAlways && locationManager.regionState != .inside {
                LocationPermission(image:  "icon_no_location",
                                   title: NSLocalizedString("lostLocationTitle", comment: ""),
                                   content: NSLocalizedString("lostLocationContent", comment: ""))
                Text("Включите WI-FI для точного определения геопозиции")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .multilineTextAlignment(.center)
                Spacer()
                if let a = placesVM.placeRoom?.address, let b = placesVM.placeRoom?.link {
                    HStack(alignment: .top){
                        Text(NSLocalizedString("addressDescription", comment: "")+": ")
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 16))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        Link(placesVM.placeRoom!.address, destination: URL(string: placesVM.placeRoom!.link)! )
                            .foregroundColor(.blue)
                            .font(.custom("Inter-Regular", size: 16))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
               
                
            } else {
                LocationPermission(image: "lost_location_icon",
                                   title: NSLocalizedString("noLocationTitle", comment: ""),
                                   content: NSLocalizedString("noLocationContent", comment: ""))
            }
            Spacer()
            
            Button(action: {
                if locationManager.locationStatus == .notDetermined {
                    locationManager.requestLocation()
                } else if locationManager.locationStatus == .authorizedWhenInUse {
                    locationManager.requestAlwaysLocation()
                } else if locationManager.locationStatus == .authorizedAlways && locationManager.regionState != .inside {
                    getRoom()
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
    
    func getRoom() {
        placesVM.loading = true
        locationManager.initLocation()
        placesVM.getRoom()
    }
}

struct LostLocationAlert_Previews: PreviewProvider {
    static var previews: some View {
        LostLocationAlert()
    }
}
