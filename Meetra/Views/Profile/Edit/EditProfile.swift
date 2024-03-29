//
//  EditProfile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI

struct EditProfile: View {
    @StateObject var profileVM = ProfileViewModel()

    @State private var selection: Int = 0
    @State private var navigate_settings: Bool = false
    
    var body: some View {
        
        ProfileNavBar(settingsColor: .black,
                      title: NSLocalizedString("profile", comment: ""),
                      showAlert: $profileVM.showAlert,
                      message: profileVM.alertMessage) {
            VStack {
                HStack {
                    Button {
                        selection = 0
                    } label: {
                        Text( NSLocalizedString("edit", comment: "") )
                            .kerning(0.24)
                            .foregroundColor(.black)
                            .font(.custom( selection == 0 ? "Inter-SemiBold" : "Inter-Regular",
                                           size: selection == 0 ? 18 : 16))
                            .padding([.vertical, .trailing])
                    }
                    
                    Button {
                        selection = 1
                    } label: {
                        Text( NSLocalizedString("preview", comment: "") )
                            .kerning(0.24)
                            .foregroundColor(.black)
                            .font(.custom( selection == 1 ? "Inter-SemiBold" : "Inter-Regular",
                                           size: selection == 1 ? 18 : 16))
                            .padding([.vertical, .trailing])
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal, 25)
                
                
                if selection == 0 {
                    ProfileEditing()
                        .environmentObject(profileVM)
                } else {
                    ProfilePreview()
                        .environmentObject(profileVM)
                }
                
                Spacer()
            }
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
