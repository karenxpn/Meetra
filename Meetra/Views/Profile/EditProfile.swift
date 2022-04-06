//
//  EditProfile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI

struct EditProfile: View {
    
    @ObservedObject var profileVM = ProfileViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
