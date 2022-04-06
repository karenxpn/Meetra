//
//  FavouritesList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.03.22.
//

import SwiftUI

struct FavouritesList: View {
    @StateObject var userVM = UserViewModel()
    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
        ZStack {
            if userVM.loading && userVM.page == 1 {
                Loading()
            } else {
                ScrollView( showsIndicators: false) {
                    LazyVGrid( columns: columns, spacing: 20) {
                        
                        ForEach( userVM.users, id: \.id) { user in
                            
                            FavouritesListCell(user: user)
                                .environmentObject(userVM)
                                .onAppear {
                                    if user.id == userVM.users.last?.id && !userVM.loading {
                                        userVM.getStarredUsers()
                                    }
                                }
                        }
                        
                    }.padding(.bottom, UIScreen.main.bounds.height * 0.1)
                        .padding(.horizontal)
                        .padding(.top)
                }.padding(.top, 1)
            }
        }.onAppear {
            userVM.getStarredUsers()
        }
    }
}

struct FavouritesList_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesList()
    }
}
