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
            
            Button {
                profileVM.updateProfile(fields: fields.fields)
            } label: {
                HStack {
                    Spacer()
                    
                    Text( NSLocalizedString("save", comment: "") )
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .opacity(fields.job.isEmpty && fields.company.isEmpty ? 0.5 : 1)
                    .cornerRadius(30)
            }.disabled(fields.job.isEmpty && fields.company.isEmpty)
            
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
