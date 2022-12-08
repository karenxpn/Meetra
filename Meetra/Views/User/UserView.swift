//
//  UserView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI

struct UserView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userVM = UserViewModel()
    @State private var showDialog: Bool = false
    @State private var showReportConfirmation: Bool = false
    
    let userID: Int
    
    var body: some View {
        ZStack {
            
            if userVM.loading {
                Loading()
            } else if userVM.user != nil {
                UserInnerView()
                    .environmentObject(userVM)
            }
            
            FriendRequestSentNotification(userID: userID)
                .environmentObject(userVM)
                .offset(y: userVM.friendRequestSentOffset)
                .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: userVM.friendRequestSentOffset)
                .gesture(DragGesture()
                    .onChanged({ gesture in
                        UIApplication.shared.endEditing()
                        if gesture.translation.height < 0 {
                            userVM.friendRequestSentOffset = gesture.translation.height
                        }
                    })
                        .onEnded({ gesture in
                            if gesture.translation.height < -40 {
                                userVM.friendRequestSentOffset = -UIScreen.main.bounds.height
                            } else {
                                userVM.friendRequestSentOffset = 0
                            }
                        })
                )
            
        }.task {
            userVM.getUser(userID: userID)
            AppAnalytics().logScreenEvent(viewName: "\(UserView.self)")
        }.alert(isPresented: $userVM.showAlert, content: {
            Alert(title: Text("Error"), message: Text(userVM.alertMessage), dismissButton: .default(Text("Got it!")))
        }).navigationBarItems(leading: Text(""), center: EmptyView(), trailing: Button {
            showDialog.toggle()
        } label: {
            Image("dots")
                .foregroundColor(.white)
        }.fullScreenCover(isPresented: $showDialog) {
            CustomActionSheet {
                
                ActionSheetButtonHelper(icon: "report_icon",
                                        label: NSLocalizedString("report", comment: ""),
                                        role: .destructive) {
                    self.showReportConfirmation.toggle()
                }.alert(NSLocalizedString("chooseReason", comment: ""), isPresented: $showReportConfirmation, actions: {
                    Button {
                        userVM.reportReason = NSLocalizedString("fraud", comment: "")
                        userVM.reportUser(id: userID)
                        self.showDialog.toggle()
                        
                    } label: {
                        Text( NSLocalizedString("fraud", comment: "") )
                    }
                    
                    Button {
                        userVM.reportReason = NSLocalizedString("insults", comment: "")
                        userVM.reportUser(id: userID)
                        self.showDialog.toggle()
                    } label: {
                        Text( NSLocalizedString("insults", comment: "") )
                    }
                    
                    Button {
                        userVM.reportReason = NSLocalizedString("fakeAccount", comment: "")
                        userVM.reportUser(id: userID)
                        self.showDialog.toggle()
                    } label: {
                        Text( NSLocalizedString("fakeAccount", comment: "") )
                    }
                    
                    Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
                    
                })
                
                Divider()
                
                ActionSheetButtonHelper(icon: "block_icon",
                                        label: NSLocalizedString("block", comment: ""),
                                        role: .destructive) {
                    self.showDialog.toggle()
                    userVM.blockUser(id: userID)
                    //                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }).onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "block_user"))) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userID: 42)
    }
}
