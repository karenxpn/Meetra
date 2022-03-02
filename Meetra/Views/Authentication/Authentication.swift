//
//  Authentication.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI
import ActionSheetPicker_3_0


struct Authentication: View {
    
    @ObservedObject var authVM = AuthViewModel()
    @State private var showPicker: Bool = false
    
    
    
    var body: some View {
        
        ZStack {
            VStack( alignment: .leading, spacing: 20) {
                Text("Ваш номер:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
                Text("Введите номер телефона для прохождения быстрой регистрации")
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                    .padding(.trailing)
                
                
                HStack {
                    
                    Button {
                        showPicker.toggle()
                        
                    } label: {
                        HStack {
                            Text( "\(authVM.country) +\(authVM.code)" )
                                .foregroundColor(.black)
                                .font(.custom("Inter-SemiBold", size: 18))
                            
                            Image("dropdown")
                            
                        }.padding(.vertical, 15)
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3, x: 0, y: 3)
                    }
                    
                    TextField("(954)411-11-33", text: $authVM.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 10)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3, x: 0, y: 3)
                }.padding(.top, 20)
                
                
                Spacer()
                
                Button {
                    authVM.sendVerificationCode()
                } label: {
                    
                    HStack {
                        Spacer()
                        
                        Text( "Продолжить" )
                            .font(.custom("Inter-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 73)
                            .background(AppColors.proceedButtonColor)
                            .opacity(authVM.phoneNumber == "" ? 0.5 : 1)
                            .cornerRadius(30)
                        
                        Spacer()
                    }
                    
                }.padding(.bottom, 30)
                    .disabled(authVM.loading)
                    .background(
                        NavigationLink(destination: VerifyPhoneNumber(), isActive: $authVM.navigateToCheckVerification, label: {
                            EmptyView()
                        }).hidden()
                    )
            }
            
        }.padding(.horizontal, 40)
            .navigationBarTitle("")
            .sheet(isPresented: $showPicker) {
                CountryCodeSelection(isPresented: $showPicker, country: $authVM.country, code: $authVM.code)
            }
            .alert(isPresented: $authVM.showAlert) {
                Alert(title: Text("Error"), message: Text(authVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
