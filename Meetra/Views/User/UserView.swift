//
//  UserView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI

struct UserView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userVM = UserViewModel()
    @State private var showDialog: Bool = false
    
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
                .offset(y: userVM.friendRequestSentOffset)
                .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: userVM.friendRequestSentOffset)
                .gesture(DragGesture()
                    .onChanged({ gesture in

                        if gesture.translation.height < 0 {
                            userVM.friendRequestSentOffset = gesture.translation.height - UIScreen.main.bounds.height / 3
                        }
                    })
                    .onEnded({ gesture in
                        if gesture.translation.height < -40 {
                            userVM.friendRequestSentOffset = -UIScreen.main.bounds.height
                        } else {
                            userVM.friendRequestSentOffset = -UIScreen.main.bounds.height / 3
                        }
                    })
                )
            
        }.task {
            userVM.getUser(userID: userID)
        }.alert(isPresented: $userVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(userVM.alertMessage), dismissButton: .default(Text("Got it!")))
        }).navigationBarItems(center: EmptyView(), trailing: Button {
            showDialog.toggle()
        } label: {
            Image("dots")
        }.fullScreenCover(isPresented: $showDialog) {
            CustomActionSheet {
                
                ActionSheetButtonHelper(icon: "report_icon",
                                        label: NSLocalizedString("report", comment: ""),
                                        role: .destructive) {
                    self.showDialog.toggle()
                    userVM.reportUser(id: userID)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Divider()
                
                ActionSheetButtonHelper(icon: "block_icon",
                                        label: NSLocalizedString("block", comment: ""),
                                        role: .destructive) {
                    self.showDialog.toggle()
                    userVM.blockUser(id: userID)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userID: 42)
    }
}
