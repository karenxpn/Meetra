//
//  AuthGenderPicker.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct AuthGenderPicker: View {
    let phone: String
    let name: String
    let birthday: String
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                print(birthday)
                print(phone)
                print(name)
            }
    }
}

struct AuthGenderPicker_Previews: PreviewProvider {
    static var previews: some View {
        AuthGenderPicker(phone: "", name: "", birthday: "")
    }
}
