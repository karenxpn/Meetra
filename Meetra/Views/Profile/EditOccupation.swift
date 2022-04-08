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
    
    @State private var job: String = ""
    @State private var company: String = ""
    
    var body: some View {
        VStack( spacing: 43) {
            
            TextFieldHelper(placeholder: "Ваше занятие", text: $job)
            TextFieldHelper(placeholder: "Компания", text: $company)

            Spacer()
            
            ButtonHelper(disabled: fields.job == job && fields.company == company,
                         label: NSLocalizedString("save", comment: "")) {
                fields.job = job
                fields.company = company
                profileVM.updateProfile(fields: fields.fields)
            }
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .leading)
        .padding(30)
        .padding(.bottom, UIScreen.main.bounds.size.height * 0.05)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Text(NSLocalizedString("occupationType", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10))
        .onAppear {
            job = fields.job
            company = fields.company
        }

    }
}

struct EditOccupation_Previews: PreviewProvider {
    static var previews: some View {
        EditOccupation(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
