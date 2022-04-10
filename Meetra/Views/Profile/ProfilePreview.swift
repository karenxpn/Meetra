//
//  ProfilePreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct ProfilePreview: View {
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some View {
        ZStack {
            if profileVM.loading {
                Loading()
            } else if profileVM.editFields != nil {
                ProfilePreviewInnerView(images: profileVM.profileImages.map{ $0.image }, fields: profileVM.editFields!)
            }
        }.onAppear {
            profileVM.getProfileUpdateFields()
        }.alert(isPresented: $profileVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
        })
    }
}

struct ProfilePreview_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePreview()
    }
}
