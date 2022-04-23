//
//  NavigationButtonHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.04.22.
//

import SwiftUI

struct NavigationButtonHelper: View {
    let label: String
    let destination: AnyView
    
    var body: some View {
        
        NavigationLink {
            destination
        } label: {
           SettingsButtonHelperContent(label: label)
        }
    }
}

struct NavigationButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonHelper(label: "Основное", destination: AnyView(Text( "Some Location" )))
    }
}
