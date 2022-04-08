//
//  EditProfileFieldBuilder.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct EditProfileFieldBuilder<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
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
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.size.height * 0.07)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text(title)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(.bottom, 10))
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text( "Error" ), message: Text( message ), dismissButton: .default(Text( "Got It" )))
            }).onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "updated"))) { _ in
                presentationMode.wrappedValue.dismiss()
            }
    }
}
