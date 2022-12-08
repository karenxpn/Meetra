//
//  AlwaysLocationAlert.swift
//  Meetra
//
//  Created by Михаил Бебуров on 06.12.2022.
//

import SwiftUI

struct AlwaysLocationAlert: View {
    @State private var settings: Bool = false
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack( spacing: 30 ){
            Spacer()
            LocationPermission(image: "icon_no_location",
                               title: NSLocalizedString("noLocationAlwaysTitle", comment: ""),
                               content: NSLocalizedString("noLocationAlwaysContent", comment: ""))
            Spacer()
            
            Button(action: {
                settings.toggle()
            }) {
                
                HStack {
                    Spacer()
                    
                    Text(NSLocalizedString("check", comment: ""))
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

