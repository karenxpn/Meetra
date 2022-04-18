//
//  ProfileNavBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.04.22.
//

import SwiftUI

struct ProfileNavBar<Content: View>: View {
    
    let title: String
    @Binding var showAlert: Bool
    let message: String
    private var content: Content
    
    init(title: String, showAlert: Binding<Bool>, message: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self._showAlert = showAlert
        self.message = message
        self.content = content()
    }
    
    var body: some View {
        content
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text(message), dismissButton: .default(Text("Got it!")))
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text(NSLocalizedString("profile", comment: ""))
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), trailing: HStack( spacing: 20) {
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
