//
//  GeneralSettings.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.04.22.
//

import SwiftUI

struct GeneralSettings: View {
    
    @StateObject private var notificationsVM = NotificationsViewModel()
    @StateObject private var locationVM = LocationManager()
    var body: some View {
        ProfileNavBar(settingsColor: AppColors.accentColor,
                      title: NSLocalizedString("general", comment: ""),
                      showAlert: .constant(false),
                      message: "") {
            
            VStack( spacing: 20 ) {
                
                NavigationButtonHelper(label: NSLocalizedString("phoneNumber", comment: ""), destination: AnyView(ChangePhoneNumber()))
                ActionButtonHelper(label: NSLocalizedString("notifications", comment: "")) {
                    notificationsVM.checkPermissionStatus { status in
                        if status == .notDetermined {
                            notificationsVM.requestPermission()
                        } else {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                }
                
                ActionButtonHelper(label: NSLocalizedString("location", comment: "")) {
                    if locationVM.status == "request" {
                        locationVM.requestLocation()
                    } else {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
                
                Spacer()
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .leading)
            .padding(30)
        }
    }
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
