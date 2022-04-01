//
//  FriendRequestList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct FriendRequestList: View {
    
    @ObservedObject var userVM = UserViewModel()

    var body: some View {
        ZStack {
            
            if userVM.loading {
                Loading()
            } else {
                LazyVStack {
                    ForEach( userVM.requests, id: \.id ) { user in
                        FriendRequestListCell(user: user)
                            .environmentObject(userVM)
                            .onAppear {
                                if user.id == userVM.requests.last?.id && !userVM.loading {
                                    userVM.getFriendRequests()
                                }
                            }
                    }
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
