//
//  VerifyPhoneNumber.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import SwiftUI

struct VerifyPhoneNumber: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State var model: RegistrationRequest
    let phone: String
    
    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            
            Text( "Код:" )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
            
            Text( "Отправили вам 4-значный код\n на номер \(phone)" )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .padding(.top, 20)
                .padding(.bottom, 50)
            
            
            OTPTextFieldView { otp in
                UIApplication.shared.endEditing()
                authVM.checkVerificationCode(code: otp)
            }
            
            HStack( spacing: 0) {
                Text( "Не пришло СМС?" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Button(action: {
                    authVM.resendVerificationCode()
                }) {
                    Text( " Отправить ещё раз" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 12))
                }
                
            }.padding(.top)
                .padding(.bottom, 30)
            
            
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
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .cornerRadius(30)
                
            }.disabled(authVM.loading)
                .background(
                    NavigationLink(destination: AuthNameInput(model: model), isActive: $authVM.proceedRegistration, label: {
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
            .alert(isPresented: $authVM.showAlert) {
                Alert(title: Text("Error"), message: Text(authVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }
    }
}

struct VerifyPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        VerifyPhoneNumber(model: RegistrationRequest(), phone: "92837408237")
    }
}
