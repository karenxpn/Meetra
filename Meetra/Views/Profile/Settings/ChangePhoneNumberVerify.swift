//
//  ChangePhoneNumberVerify.swift
//  Meetra
//
//  Created by Karen Mirakyan on 23.04.22.
//

import SwiftUI

struct ChangePhoneNumberVerify: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileVM: ProfileViewModel
    let phone: String
    
    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            
            Text( "Код:" )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
            
            VStack( alignment: .leading, spacing: 5) {
                Text( "Отправили вам 4-значный код\n на номер \(phone)" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(NSLocalizedString("change", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 16))
                        .underline()
                }

            }.padding(.top, 20)
                .padding(.bottom, 50)

            
            
            OTPTextFieldView { otp in
                UIApplication.shared.endEditing()
                profileVM.OTP = otp
            }
            
            HStack( spacing: 0) {
                Text( "Не пришло СМС?" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Button(action: {
//                    profileVM.resendVerificationCode()
                }) {
                    Text( " Отправить ещё раз" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 12))
                        .underline()
                }
                
            }.padding(.top)
                .padding(.bottom, 30)
            
            
            Spacer()
            
            
            ButtonHelper(disabled: profileVM.OTP.count != 4,
                         label: NSLocalizedString("proceed", comment: "")) {
                profileVM.checkVerificationCode()
            }
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
            .alert(isPresented: $profileVM.showAlert) {
                Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "phone_updated"))) { _ in
                presentationMode.wrappedValue.dismiss()
            }
    }
}

struct ChangePhoneNumberVerify_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhoneNumberVerify(phone: "+37493936313")
    }
}
