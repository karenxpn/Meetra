//
//  EditEducation.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct EditEducation: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State var fields: ProfileEditFieldsViewModel
    @State private var school: String = ""
    
    var body: some View {
        
        EditProfileFieldBuilder(title: NSLocalizedString("education", comment: "")) {
            VStack( spacing: 43) {
                
                TextFieldHelper(placeholder: "Учебное заведение", text: $school)
                
                Spacer()
                
                ButtonHelper(disabled: fields.school == school,
                             label: NSLocalizedString("save", comment: "")) {
                    fields.school = school
                    profileVM.updateProfile(fields: fields.fields)
                }
                
            }
        }
        .onAppear {
            school = fields.school
        }
    }
}

struct EditEducation_Previews: PreviewProvider {
    static var previews: some View {
        EditEducation(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
