//
//  AuthGenderPicker.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct AuthGenderPicker: View {
    @State var model: RegistrationRequest
    
    let genders = ["Женщина", "Мужчина", "Небинарная персона"]
    @State private var selected_gender = ""
    @State private var navigate: Bool = false
    @State private var showGender: Bool = true
    
    
    var body: some View {
        ZStack {
            VStack( alignment: .leading, spacing: 30) {
                
                Text( "Вы:" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
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
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
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
                
                ButtonHelper(disabled: selected_gender.isEmpty,
                             label: NSLocalizedString("proceed", comment: "")) {
                    
                    navigate.toggle()
                    model.gender = selected_gender
                    model.showGender = showGender
                }.background(
                        NavigationLink(destination: AuthProfileImages(model: model), isActive: $navigate, label: {
                            EmptyView()
                        }).hidden()
                    )
                
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
            
            AuthProgress(page: 2)
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct AuthGenderPicker_Previews: PreviewProvider {
    static var previews: some View {
        AuthGenderPicker(model: RegistrationRequest())
    }
}
