//
//  EditProfile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI

struct EditProfile: View {
    @State private var selection: Int = 0
    
    var body: some View {
        
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
            } else {
                ProfilePreview()
            }
            
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Text(NSLocalizedString("profile", comment: ""))
            .foregroundColor(.black)
            .font(.custom("Inter-Black", size: 28))
            .padding(.bottom, 10), trailing: HStack( spacing: 20) {
                Button {
                    
                } label: {
                    Image("settings_icon")
                }
                
                Button {
                    
                } label: {
                    Image("icon_ring")
                        .foregroundColor(.black)
                }
            })
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
