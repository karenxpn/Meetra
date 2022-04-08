//
//  EditOccupation.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct EditOccupation: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State var fields: ProfileEditFieldsViewModel
    
    var body: some View {
        VStack( spacing: 43) {
            
            TextFieldHelper(placeholder: "Ваше занятие", text: $fields.job)
            TextFieldHelper(placeholder: "Компания", text: $fields.company)

            Spacer()
            
            ButtonHelper(disabled: fields.job.isEmpty && fields.company.isEmpty,
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
        .navigationBarItems(leading: Text(NSLocalizedString("occupationType", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10))

    }
}

struct EditOccupation_Previews: PreviewProvider {
    static var previews: some View {
        EditOccupation(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
