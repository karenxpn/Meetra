//
//  AuthLocationPermission.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import SwiftUI
import CoreLocationUI

struct AuthLocationPermission: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        
        LocationPermission(image: "location_icon", title: NSLocalizedString("authLocationRequest", comment: ""), content: NSLocalizedString("authLocationRequestContent", comment: ""))
            .environmentObject(locationManager)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                locationManager.navigate = true
            }, label: {
                Text( "Пропустить")
                    .foregroundColor(AppColors.proceedButtonColor)
                    .font(.custom("Inter-SemiBold", size: 18))
            }))
    }
}

struct AuthLocationPermission_Previews: PreviewProvider {
    static var previews: some View {
        AuthLocationPermission()
    }
}




struct LocationPermission: View {
    @EnvironmentObject var locationManager: LocationManager
    let image: String
    let title: String
    let content: String
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 140)
            
            
            Text( title )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
                .multilineTextAlignment(.center)
            
            
            Text( content )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                locationManager.requestLocation()
            }) {
                
                HStack {
                    Spacer()
                    
                    Text( "Включить" )
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .cornerRadius(30)
            }            .background(
                NavigationLink(destination: AuthNotificationPermission(), isActive: $locationManager.navigate, label: {
                    EmptyView()
                }).hidden()
            )
            
            
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).padding(30)
    }
}
