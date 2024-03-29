//
//  AuthProfileImages.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI

struct AuthProfileImages: View {
    @StateObject private var authVM = AuthViewModel()
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
                            
                            ProfileImageBox(images: $authVM.imageKeys, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.22,
                                            width:  UIScreen.main.bounds.size.width * 0.38,
                                            index: index)
                            .environmentObject(authVM)
                        }
                    }
                    
                    HStack(spacing: 30) {
                        ForEach(2...4, id: \.self) { index in
                            
                            ProfileImageBox(images: $authVM.imageKeys, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.14,
                                            width:  UIScreen.main.bounds.size.width * 0.23,
                                            index: index)
                            .environmentObject(authVM)
                        }
                    }
                    
                    
                    Text( "Фото профиля вы сможете изменить позже" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                    
                    
                    Spacer()
                    
                    ButtonHelper(disabled: authVM.imageKeys.count < 2,
                                 label: NSLocalizedString("proceed", comment: "")) {
                        model.images = authVM.imageKeys.map({ $0.1 })
                        navigate.toggle()
                    }.background(
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
                Gallery(action: { images in
                    authVM.getPreSignedURL(images: images)
                }, existingImageCount: authVM.imageKeys.count)
            }.alert(isPresented: $authVM.showAlert) {
                Alert(title: Text( "Error" ), message: Text( authVM.alertMessage), dismissButton: .cancel(Text( "Got It!" )))
            }
    }
}

struct AuthProfileImages_Previews: PreviewProvider {
    static var previews: some View {
        AuthProfileImages(model: RegistrationRequest())
    }
}
