//
//  Authentication.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI
import ActionSheetPicker_3_0


struct Authentication: View {
    
    @StateObject var authVM = AuthViewModel()
    @State private var showPicker: Bool = false
    @State private var model = RegistrationRequest()
    @State private var animate: Bool = false
    
    
    var body: some View {
        
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
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                
                TextField("(954)411-11-33", text: $authVM.phoneNumber)
                    .keyboardType(.phonePad)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
            }.padding(.top, 20)
            
            HStack {
                
                Button {
                    authVM.agreement.toggle()
                } label: {
                    ZStack {
                        if authVM.agreement {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(AppColors.accentColor)
                                .frame(width: 16, height: 16, alignment: .center)
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.black, lineWidth: 1)
                                .frame(width: 16, height: 16, alignment: .center)
                        }
                        
                        if authVM.agreement {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10, alignment: .center)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Link(NSLocalizedString("termsOfUse", comment: ""), destination: URL(string: Credentials.terms_of_use)!)
                    .foregroundColor(.blue)
                    .font(.custom("Inter-Regular", size: 12))
                
                Text( "*Required" )
                    .foregroundColor(.red)
                    .font(.custom("Inter-Regular", size: 10))
                
            }.scaleEffect(animate ? 1.3 : 1)
            
            
            HStack {
                
                Spacer()
                
                ButtonHelper(disabled: authVM.phoneNumber == "" || authVM.loading,
                             label: NSLocalizedString("proceed", comment: "")) {
                    if authVM.agreement {
                        authVM.sendVerificationCode()
                        
                    } else{
                        withAnimation(.easeInOut(duration: 0.7)) {
                            animate.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                animate.toggle()
                            }
                        }
                        
                    }
                }
            }.padding(.bottom, 30)
                .background(
                    NavigationLink(destination: VerifyPhoneNumber(model: model, phone: "+\(authVM.code) \(authVM.phoneNumber)")
                        .environmentObject(authVM), isActive: $authVM.navigate, label: {
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
