//
//  AuthBio.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI

struct AuthBio: View {
    @State var model: RegistrationRequest
    @State private var navigate: Bool = false
    
    @State private var bio: String = ""
    var body: some View {
        ZStack {
            
            VStack( alignment: .leading, spacing: 30) {
                
                Text("О себе:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
                ZStack(alignment: .leading) {
                    
                    TextEditor(text: $bio)
                        .foregroundColor(Color.gray)
                        .font(.custom("Inter-Regular", size: 16))
                        .frame(height: 150)
                        .background(AppColors.addProfileImageBG)
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }.cornerRadius(10)
                    
                    if bio.isEmpty {
                        
                        VStack {
                            Text("Расскажите вкратце о себе")
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundColor(Color.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                            Spacer()
                        }.frame(height: 150)
                    }
                }
                
                Text( "Этот раздел вы сможете\nизменить позже" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Spacer()
                
                Button {
                    model.bio = bio
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
                        .opacity(bio.isEmpty ? 0.5 : 1)
                        .cornerRadius(30)
                }.disabled(bio.isEmpty)
                    .background(
                        NavigationLink(destination: AuthInterests(model: model), isActive: $navigate, label: {
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
            
            AuthProgress(page: 4)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                navigate.toggle()
            }, label: {
                Text( "Пропустить")
                    .foregroundColor(AppColors.proceedButtonColor)
                    .font(.custom("Inter-SemiBold", size: 18))
            }))
    }
}

struct AuthBio_Previews: PreviewProvider {
    static var previews: some View {
        AuthBio(model: RegistrationRequest(bio: "12"))
    }
}
