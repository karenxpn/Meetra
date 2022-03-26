//
//  UserView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var userVM = UserViewModel()
    
    init(userID: Int) {
        self.userVM.getUser(userID: userID)
        // get user with userID
    }
    
    var body: some View {
        VStack {
            
            if userVM.loading {
                Loading()
            } else if userVM.user != nil {
                Text( "User" )
            }
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
