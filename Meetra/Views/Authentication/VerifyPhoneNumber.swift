//
//  VerifyPhoneNumber.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import SwiftUI
import Combine

struct VerifyPhoneNumber: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State var model: RegistrationRequest
    @State private var buttonDisabled = false
    @State private var timeRemaining = 30
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
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
                authVM.OTP = otp
            }
            HStack( spacing: 0) {
                Text( "Не пришло СМС?" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Button(action: {
                    authVM.resendVerificationCode()
                    self.buttonDisabled = true
                    self.timer = Timer.publish(every: 1, on: .main, in: .common)
                    self.connectedTimer = timer.connect()
                }) {
                    Text( " Отправить ещё раз" )
                        .foregroundColor(changeColor(buttonDisabled: self.buttonDisabled))
                        .font(.custom("Inter-SemiBold", size: 12))
                }.disabled(self.buttonDisabled == true)
                    .onReceive(timer) { time in
                        if timeRemaining > 1 {
                            self.timeRemaining -= 1
                        } else {
                            self.connectedTimer?.cancel()
                            self.buttonDisabled = false
                            self.timeRemaining = 30
                        }
                    }
                
            }.padding(.top)
                .padding(.bottom, 5)
            
            Text("Попробуйте через \(self.timeRemaining)").opacity(self.buttonDisabled ? 1 : 0).font(.custom("Inter-Regular", size: 10))
            
            Spacer()
            
            
            ButtonHelper(disabled: authVM.OTP.count != 4,
                         label: NSLocalizedString("proceed", comment: "")) {
                authVM.checkVerificationCode()
            }.background(
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

func changeColor(buttonDisabled: Bool) -> Color {
    return buttonDisabled ? Color.gray : Color.black
}

struct VerifyPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        VerifyPhoneNumber(model: RegistrationRequest(), phone: "92837408237")
    }
}
