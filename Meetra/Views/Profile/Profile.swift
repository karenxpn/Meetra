//
//  Profile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI

struct Profile: View {
    
    @ObservedObject var profileVM = ProfileViewModel()
    var body: some View {
        NavigationView {
            ZStack {

                
            }
            .alert(isPresented: $profileVM.showAlert, content: {
                Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text("Meetra")
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(), trailing: HStack( spacing: 20) {
                    Button {

                    } label: {
                        Image("settings_icon")
                    }
                    
                    Button {
                        
                    } label: {
                        Image("icon_ring")
                            .foregroundColor(.black)
                    }
                }).onAppear {
                    profileVM.getProfile()
                }
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
