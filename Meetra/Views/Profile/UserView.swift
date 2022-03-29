//
//  UserView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var userVM = UserViewModel()
    let userID: Int
    
    var body: some View {
        ZStack {
            
            if userVM.loading {
                Loading()
            } else if userVM.user != nil {
                UserInnerView()
                    .environmentObject(userVM)
            }
        }.task {
            print( "Appeared" )
            userVM.getUser(userID: userID)
        }.alert(isPresented: $userVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(userVM.alertMessage), dismissButton: .default(Text("Got it!")))
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userID: 1)
    }
}
