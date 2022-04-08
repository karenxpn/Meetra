//
//  EditGender.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct EditGender: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State var fields: ProfileEditFieldsViewModel
    
    let genders = ["Женщина", "Мужчина", "Небинарная персона"]
    @State private var selected_gender = ""
    @State private var showGender: Bool = true
    
    var body: some View {
        VStack( alignment: .leading, spacing: 30) {
            
            ForEach( genders, id: \.self ) { gender in
                
                Button {
                    selected_gender = gender
                } label: {
                    HStack {
                        Text( gender )
                            .foregroundColor(gender == selected_gender ? .white : .black)
                            .font(.custom("Inter-SemiBold", size: 18))
                            .padding(.leading)
                        
                        Spacer()
                    }.padding(.vertical, 14)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(gender == selected_gender ? AppColors.accentColor : .white)
                        .cornerRadius(10)
                        .shadow(radius: 3, x: 0, y: 3)
                }
            }
            
            Spacer()
            
            HStack {
                Button {
                    showGender.toggle()
                } label: {
                    ZStack {
                        Image("checkbox")
                        if !showGender {
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                                .font(Font.system(size: 15, weight: .semibold))
                            
                        }
                    }
                }
                
                Text("Не показывать мой пол в профиле")
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
            }
            
            ButtonHelper(disabled: selected_gender == fields.gender && showGender == fields.showGender,
                         label: NSLocalizedString("save", comment: "")) {
                
                fields.gender = selected_gender
                fields.showGender = showGender
                profileVM.updateProfile(fields: fields.fields)
            }
            
        }
        .padding(30)
        .padding(.bottom, UIScreen.main.bounds.size.height * 0.05)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Text(NSLocalizedString("gender", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10))
        .onAppear {
            showGender = fields.showGender
            selected_gender = fields.gender
        }
    }
}

struct EditGender_Previews: PreviewProvider {
    static var previews: some View {
        EditGender(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
