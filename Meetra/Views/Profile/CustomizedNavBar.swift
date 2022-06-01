//
//  ProfileNavBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.04.22.
//

import SwiftUI

struct ProfileNavBar<Content: View>: View {
    
    let settingsColor: Color
    let title: String
    @Binding var showAlert: Bool
    let message: String
    private var content: Content
    
    init(settingsColor:  Color, title: String, showAlert: Binding<Bool>, message: String, @ViewBuilder content: () -> Content) {
        self.settingsColor = settingsColor
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
            .navigationBarItems(leading: Text(title)
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), trailing: HStack( spacing: 20) {
                    NavigationLink(destination: {
                        Settings()
                    }, label: {
                        Image("settings_icon")
                            .foregroundColor(settingsColor)
                    })
                    
                    NotificationButton()
                })
    }
}
