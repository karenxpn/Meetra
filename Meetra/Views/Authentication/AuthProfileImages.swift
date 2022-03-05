//
//  AuthProfileImages.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI

struct AuthProfileImages: View {
    @State var model: RegistrationRequest
    
    @State private var navigate: Bool = false
    @State private var showPicker: Bool = false
    
    var body: some View {
        ZStack {
            
            ScrollView(showsIndicators: false) {
                VStack( alignment: .leading, spacing: 30) {
                    
                    Text("Фото:")
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 30))
                    
                    
                    Text( "Загрузите минимум 2 фото,\nкоторые будут отображаться\nв вашем профиле" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 16))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack(spacing: 30) {
                        ForEach(0...1, id: \.self) { index in
                            
                            ProfileImageBox(model: $model, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.22,
                                            width:  UIScreen.main.bounds.size.width * 0.38,
                                            index: index)
                            
                        }
                    }
                    
                    HStack(spacing: 30) {
                        ForEach(2...4, id: \.self) { index in
                            
                            ProfileImageBox(model: $model, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.14,
                                            width:  UIScreen.main.bounds.size.width * 0.23,
                                            index: index)
                        }
                    }
                    
                    
                    Text( "Фото профиля вы сможете изменить позже" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                    
                    
                    
                    Spacer()
                    
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
                            .opacity(model.images.count < 2 ? 0.5 : 1)
                            .cornerRadius(30)
                    }.disabled(model.images.count < 2)
                        .background(
                            NavigationLink(destination: AuthBio(model: model), isActive: $navigate, label: {
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
            }.padding(.top, 1)
            
            AuthProgress(page: 3)
        }.navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showPicker) {
                AuthGallery(model: $model)
            }
    }
}

struct AuthProfileImages_Previews: PreviewProvider {
    static var previews: some View {
        AuthProfileImages(model: RegistrationRequest())
    }
}
