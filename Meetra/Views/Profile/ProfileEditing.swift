//
//  ProfileEditing.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct ProfileEditing: View {
    @StateObject var profileVM = ProfileViewModel()

    var body: some View {
        ZStack {
            if profileVM.loading {
                Loading()
            } else {
                if profileVM.editFields != nil {
                    ProfileEditingInnerView(fields: profileVM.editFields!)
                        .environmentObject(profileVM)
                }
            }
        }.onAppear {
            profileVM.getProfileUpdateFields()
        }.alert(isPresented: $profileVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
        })
    }
}

struct ProfileEditing_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditing()
    }
}
