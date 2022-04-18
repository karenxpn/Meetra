//
//  Settings.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.04.22.
//

import SwiftUI

struct Settings: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State private var showDeleteAccountDialog: Bool = false
    
    var body: some View {
        ProfileNavBar(settingsColor: AppColors.accentColor,
                      title: NSLocalizedString("settings", comment: ""),
                      showAlert: .constant(false),
                      message: "") {
            
            
            ScrollView ( showsIndicators: false ) {
                VStack( spacing: 20 ) {
                    
                    NavigationButtonHelper(label: "Основное", destination: AnyView(Text( "General" )))
                    NavigationButtonHelper(label: "Помощь", destination: AnyView(Text( "Помощь" )))
                    NavigationButtonHelper(label: "Сообщество", destination: AnyView(Text( "Сообщество" )))
                    NavigationButtonHelper(label: "Юр. информация", destination: AnyView(Text( "Юр. информация" )))

                    
                    Spacer()
                        .padding(.vertical, 70)
                    
                    ButtonHelper(disabled: false,
                                 label: NSLocalizedString("logout", comment: "")) {
                        profileVM.logout()
                    }
                    
                    
                    Button {
                        showDeleteAccountDialog.toggle()
                    } label: {
                        Text( NSLocalizedString("deleteAccount", comment: ""))
                            .foregroundColor(.red)
                            .font(.custom("Inter-SemiBold", size: 18))
                        
                    }
                    
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .leading)
                .padding(30)
                .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
            }.padding(.top, 1)
        }.alert(isPresented: $showDeleteAccountDialog) {
            Alert(title: Text( NSLocalizedString("deleteAccount", comment: "")),
                  message: Text( NSLocalizedString("afterDeletion", comment: "")),
                  primaryButton: .cancel(Text(NSLocalizedString("no", comment: ""))),
                  secondaryButton: .default(Text( NSLocalizedString("yes", comment: "")), action: {
                profileVM.deactivateAccount()
            }))
        }

    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
