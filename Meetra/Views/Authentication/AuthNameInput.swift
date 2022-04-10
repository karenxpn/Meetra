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
        ZStack {
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
                
                ButtonHelper(disabled: name.count < 3,
                             label: NSLocalizedString("proceed", comment: "")) {
                    model.name = name
                    navigate.toggle()
                }.background(
                        NavigationLink(destination: AuthBirthday(model: model), isActive: $navigate, label: {
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
            
            AuthProgress(page: 0)
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct AuthNameInput_Previews: PreviewProvider {
    static var previews: some View {
        AuthNameInput(model: RegistrationRequest())
    }
}
