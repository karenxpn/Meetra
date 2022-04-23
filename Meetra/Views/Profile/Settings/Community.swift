//
//  Community.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.04.22.
//

import SwiftUI

struct Community: View {
    
    var body: some View {
        ProfileNavBar(settingsColor: AppColors.accentColor,
                      title: NSLocalizedString("community", comment: ""),
                      showAlert: .constant(false),
                      message: "") {
            
            VStack( spacing: 20 ) {
                
                ActionButtonHelper(label: NSLocalizedString("rules", comment: "")) {
                    if let url = URL(string: Credentials.terms_of_use) {
                        UIApplication.shared.open(url)
                    }
                }
                
                ActionButtonHelper(label: NSLocalizedString("privacy", comment: "")) {
                    if let url = URL(string: Credentials.privacy_policy) {
                        UIApplication.shared.open(url)
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

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
