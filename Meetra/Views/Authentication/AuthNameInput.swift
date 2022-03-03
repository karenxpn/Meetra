//
//  AuthNameInput.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct AuthNameInput: View {
    @State var model: RegistrationRequest
    @State private var name: String = ""
    @State private var navigate: Bool = false
    
    var body: some View {
        VStack( alignment: .leading, spacing: 30) {
            
            Text("Ваше имя:")
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
            
            
            Text( "Это имя будут видеть другие пользователи" )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
            
            TextField("Как вас зовут?", text: $name)
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3, x: 0, y: 3)
            
            Text( "Имя нельзя будет изменить в настройках" )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 12))
            
            
            Spacer()
            
            Button {
                model.name = name
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
                    .opacity(name.count < 3 ? 0.5 : 1)
                    .cornerRadius(30)
            }.disabled(name.count < 3)
                .background(
                    NavigationLink(destination: AuthBirthday(model: model), isActive: $navigate, label: {
                        EmptyView()
                    }).hidden()
                )

            
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

struct AuthNameInput_Previews: PreviewProvider {
    static var previews: some View {
        AuthNameInput(model: RegistrationRequest(phone: "+79094215513", name: "Karen", birthday: "", gender: "", private_gender: false))
    }
}
