//
//  AuthGenderPicker.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct AuthGenderPicker: View {
    let phone: String
    let name: String
    let birthday: String
    
    let genders = ["Женщина", "Мужчина", "Небинарная персона "]
    @State private var selected_gender = ""
    @State private var navigate: Bool = false
    @State private var private_gender: Bool = false
    
    
    var body: some View {
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
                        .shadow(radius: 3, x: 0, y: 3)
                }
            }
            
            Spacer()
            
            HStack {
                Button {
                    private_gender.toggle()
                } label: {
                    ZStack {
                        Image("checkbox")
                        if private_gender {
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
            
            Button {
                navigate.toggle()
            } label: {
                HStack {
                    Spacer()
                    
                    Text( "Продолжить" )
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .opacity(selected_gender.isEmpty ? 0.5 : 1)
                    .cornerRadius(30)
            }.disabled(selected_gender.isEmpty)
//                .background(
//                    NavigationLink(destination: AuthGenderPicker(phone: phone, name: name, birthday: birthday), isActive: $navigate, label: {
//                        EmptyView()
//                    }).hidden()
//                )
            
        }.navigationBarTitle("", displayMode: .inline)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
    }
}

struct AuthGenderPicker_Previews: PreviewProvider {
    static var previews: some View {
        AuthGenderPicker(phone: "", name: "", birthday: "")
    }
}
