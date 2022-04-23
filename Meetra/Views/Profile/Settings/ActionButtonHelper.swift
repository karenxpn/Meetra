//
//  ActionButtonHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.04.22.
//

import SwiftUI

struct ActionButtonHelper: View {
    
    let label: String
    let action: (() -> Void)
    
    var body: some View {
        
        Button(action: action) {
            SettingsButtonHelperContent(label: label)
        }
    }
}

struct ActionButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonHelper(label: "Лицензия", action: {
            if let url = URL(string: "https://www.google.com") {
                   UIApplication.shared.open(url)
                }
        })
    }
}
