//
//  FriendRequestList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct FriendRequestList: View {
    
    @StateObject var userVM = UserViewModel()
    
    var body: some View {
        ZStack {
            
            if userVM.loading && userVM.page == 1{
                Loading()
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity)
            } else {
                ScrollView( showsIndicators: false) {
                    LazyVStack( spacing: 0) {
                        ForEach( userVM.requests, id: \.id ) { user in
                            FriendRequestListCell(user: user)
                                .environmentObject(userVM)
                                .onAppear {
                                    if user.id == userVM.requests.last?.id && !userVM.loading {
                                        userVM.getFriendRequests()
                                    }
                                }
                        }
                    }.padding(.bottom, UIScreen.main.bounds.height * 0.1)
                }
            }
            
        }.onAppear {
            userVM.getFriendRequests()
        }
    }
}

struct FriendRequestList_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestList()
    }
}
