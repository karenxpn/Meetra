//
//  FavouritesListCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.03.22.
//

import SwiftUI

struct FavouritesListCell: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var navigate: Bool = false
    let user: UserPreviewModel
    
    var body: some View {
        ZStack( alignment: .bottomLeading) {
            
            Button {
                navigate.toggle()
            } label: {
                ImageHelper(image: user.image, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.4,
                           height: UIScreen.main.bounds.size.height * 0.22)
                    .clipped()
                    .cornerRadius(25)
            }.background(
                NavigationLink(destination: UserView(userID: user.id), isActive: $navigate, label: {
                    EmptyView()
                }).hidden()
            )
            
            HStack {
                Spacer()
                VStack {
                    Button {
                        // remove from favourites
                    } label: {
                        Image("delete_icon")
                            .padding(10)
                            .background(AppColors.proceedButtonColor)
                            .cornerRadius(30)
                            .offset(x: 10, y: -10)
                    }
                    
                    Spacer()
                }
            }
            
            Text( user.name )
                .foregroundColor(.white)
                .font(.custom("Inter-SemiBold", size: 18))
                .padding(.leading, 15)
                .padding(.bottom, 10)
            
        }.frame(width: UIScreen.main.bounds.width * 0.4,
                height: UIScreen.main.bounds.size.height * 0.22)
    }
}

struct FavouritesListCell_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesListCell(user: AppPreviewModels.placeRoom.users[0])
            .environmentObject(UserViewModel())
    }
}
