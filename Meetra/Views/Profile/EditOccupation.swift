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
        
        EditProfileFieldBuilder(title: NSLocalizedString("occupationType", comment: ""),
                                showAlert: $profileVM.showAlert,
                                message: profileVM.alertMessage) {
            
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
            }
        }.onAppear {
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
