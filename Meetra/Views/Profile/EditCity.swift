//
//  EditCity.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct EditCity: View {
    @StateObject var profileVM = ProfileViewModel()
    @State var fields: ProfileEditFieldsViewModel
    
    @State private var city: String = ""
    
    var body: some View {
        
        EditProfileFieldBuilder(title: NSLocalizedString("city", comment: ""),
                                showAlert: $profileVM.showAlert,
                                message: profileVM.alertMessage) {
            
            VStack( spacing: 43) {
                
                TextFieldHelper(placeholder: "Город проживания", text: $city)
                
                Spacer()
                
                ButtonHelper(disabled: city == fields.city,
                             label: NSLocalizedString("save", comment: "")) {
                    fields.city = city
                    profileVM.updateProfile(fields: fields.fields)
                }
            }
            
        }.onAppear {
            city = fields.city
        }
    }
}

struct EditCity_Previews: PreviewProvider {
    static var previews: some View {
        EditCity(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
