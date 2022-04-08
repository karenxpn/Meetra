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
    
    var body: some View {
        VStack( spacing: 43) {
            
            TextFieldHelper(placeholder: "Город проживания", text: $fields.city)

            Spacer()
            
            ButtonHelper(disabled: fields.city.isEmpty,
                         label: NSLocalizedString("save", comment: "")) {
                profileVM.updateProfile(fields: fields.fields)
            }
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .leading)
        .padding(30)
        .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Text(NSLocalizedString("city", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10))
    }
}

struct EditCity_Previews: PreviewProvider {
    static var previews: some View {
        EditCity(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
