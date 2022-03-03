//
//  AuthBirthday.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

enum BirthdayForm: Hashable {
    case day
    case month
    case year
}

struct AuthBirthday: View {
    @State var model: RegistrationRequest
    
    @State private var day: String = ""
    @State private var month: String = ""
    @State private var year: String = ""
    @FocusState private var focusedField: BirthdayForm?
    @State private var navigate: Bool = false
    
    
    
    var body: some View {
        ZStack {
            VStack( alignment: .leading, spacing: 30) {
                
                Text("Ваш день\nрождения:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
                
                Text( "Остальные увидят только\nваш возраст" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                
                HStack {
                    BirthdayFields(placeholder: "ДД", width: 61, date: $day)
                        .focused($focusedField, equals: .day)
                    
                    BirthdayFields(placeholder: "ММ", width: 61, date: $month)
                        .focused($focusedField, equals: .month)
                    
                    
                    BirthdayFields(placeholder: "ГГГГ", width: 72, date: $year)
                        .focused($focusedField, equals: .year)
                }
                
                
                
                Spacer()
                
                
                Button {
                    model.birthday = "\(day)/\(month)/\(year)"
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
                        .opacity(( day.count < 2 || month.count < 2 || year.count < 4 ) ? 0.5 : 1)
                        .cornerRadius(30)
                }.disabled(( day.count < 2 || month.count < 2 || year.count < 4 ))
                    .background(
                        NavigationLink(destination: AuthGenderPicker(model: model), isActive: $navigate, label: {
                            EmptyView()
                        }).hidden()
                    )
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
                .padding(30)
            
            AuthProgress(page: 1)
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: day) { value in
                if value.count == 2 {
                    focusedField = .month
                }
            }.onChange(of: month) { value in
                if value.count == 2 {
                    focusedField = .year
                }
            }.onChange(of: year) { value in
                if value.count == 4 {
                    focusedField = nil
                }
            }
    }
}

struct AuthBirthday_Previews: PreviewProvider {
    static var previews: some View {
        AuthBirthday(model: RegistrationRequest(phone: "023902384", name: "Karen", birthday: "", gender: "", private_gender: false))
    }
}