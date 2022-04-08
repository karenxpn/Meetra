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
        VStack( spacing: 43) {
            
            TextFieldHelper(placeholder: "Учебное заведение", text: $school)

            Spacer()
            
            ButtonHelper(disabled: fields.school == school,
                         label: NSLocalizedString("save", comment: "")) {
                fields.school == school
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
        .navigationBarItems(leading: Text(NSLocalizedString("education", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10))
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
