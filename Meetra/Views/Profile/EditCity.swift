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
        VStack( spacing: 43) {
            
            TextFieldHelper(placeholder: "Город проживания", text: $city)

            Spacer()
            
            ButtonHelper(disabled: city == fields.city,
                         label: NSLocalizedString("save", comment: "")) {
                fields.city = city
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
        .onAppear {
            city = fields.city
        }
    }
}

struct EditCity_Previews: PreviewProvider {
    static var previews: some View {
        EditCity(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
