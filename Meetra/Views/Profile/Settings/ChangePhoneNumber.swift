//
//  ChangePhoneNumber.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.04.22.
//

import SwiftUI

struct ChangePhoneNumber: View {
    @StateObject var profileVM = ProfileViewModel()
    @State private var showPicker: Bool = false
    
    @FocusState private var isFocused: Bool
    @State private var change: Bool = false
    
    @AppStorage( "user_phone_number" ) private var user_phone: String = "(954)411-11-33"
    
    var body: some View {
        VStack( alignment: .leading, spacing: 20) {
            Text(NSLocalizedString("yourPhoneNumber", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
            
            Text(NSLocalizedString( change ? "newPhoneNumber" : "toChangePhone", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .padding(.trailing)
            
            
            HStack {
                
                Button {
                    showPicker.toggle()
                    
                } label: {
                    HStack {
                        Text( "\(profileVM.country) +\(profileVM.code)" )
                            .foregroundColor(.black)
                            .font(.custom("Inter-SemiBold", size: 18))
                        
                        Image("dropdown")
                        
                    }.padding(.vertical, 15)
                        .padding(.horizontal, 10)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                
                TextField(user_phone, text: $profileVM.phoneNumber)
                    .keyboardType(.phonePad)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    .focused($isFocused)
                    .onChange(of: isFocused) { value in
                        if value == true {
                            change = true
                        }
                    }
            }.padding(.top, 20)
            
            
            Spacer()
            
            if !change {
                ButtonHelper(disabled: false,
                             label: NSLocalizedString("change", comment: "")) {
                    change = true
                    isFocused = true
                }
            } else {
                ButtonHelper(disabled: profileVM.phoneNumber == "" || profileVM.loading,
                             label: NSLocalizedString("proceed" , comment: "")) {
                    profileVM.sendVerificationCode()
                }
                    .background(
                        NavigationLink(destination: ChangePhoneNumberVerify(phone: "+\(profileVM.code) \(profileVM.phoneNumber)")
                            .environmentObject(profileVM), isActive: $profileVM.navigateToCheck, label: {
                                EmptyView()
                            }).hidden()
                    )
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
            .sheet(isPresented: $showPicker) {
                CountryCodeSelection(isPresented: $showPicker,
                                     country: $profileVM.country,
                                     code: $profileVM.code)
            }
            .alert(isPresented: $profileVM.showAlert) {
                Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }.onAppear {
                change = false
            }
    }
}

struct ChangePhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhoneNumber()
    }
}
