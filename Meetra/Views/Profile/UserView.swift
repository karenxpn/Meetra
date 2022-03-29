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
            
            FriendRequestSentNotification()
                .offset(y: userVM.friendRequestSent ? -UIScreen.main.bounds.height / 3 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: userVM.friendRequestSent)
                .gesture(DragGesture()
                    .onEnded({ gesture in
                        if gesture.translation.height < -30 {
                            userVM.friendRequestSent.toggle()
                        }
                    })
                )
            
            
        }.task {
            userVM.getUser(userID: userID)
        }.alert(isPresented: $userVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(userVM.alertMessage), dismissButton: .default(Text("Got it!")))
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userID: 42)
    }
}
