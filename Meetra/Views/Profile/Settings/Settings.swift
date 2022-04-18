//
//  Settings.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.04.22.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        ProfileNavBar(navigate: .constant(true),
                      title: NSLocalizedString("settings", comment: ""),
                      showAlert: .constant(false),
                      message: "") {
            Text( "settings" )
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
