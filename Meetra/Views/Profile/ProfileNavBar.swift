//
//  ProfileNavBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.04.22.
//

import SwiftUI

struct ProfileNavBar<Content: View>: View {
    
    @Binding var navigate: Bool
    let title: String
    @Binding var showAlert: Bool
    let message: String
    private var content: Content
    
    init(navigate:  Binding<Bool>, title: String, showAlert: Binding<Bool>, message: String, @ViewBuilder content: () -> Content) {
        self._navigate = navigate
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
                    Button {
                        navigate.toggle()
                    } label: {
                        Image("settings_icon")
                            .foregroundColor(navigate ? AppColors.accentColor : .black)
                    }.background(
                        NavigationLink(isActive: $navigate, destination: {
                            Settings()
                        }, label: {
                            EmptyView()
                        }).hidden()
                    )
                    
                    Button {
                        
                    } label: {
                        Image("icon_ring")
                            .foregroundColor(.black)
                    }
                })
    }
}
