//
//  AppPreviewModels.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
struct AppPreviewModels {
    static let userModel = UserModel(id: 1, name: "Karen", age: 22, online: true, starred: false, school: "RAU", location: "Yerevan, Armenia", bio: "Люблю плёночные фотики, котиков и фалафель", interests: [UserInterestModel(same: false, name: "Travel"), UserInterestModel(same: false, name: "Coffee")], images: ["https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg"], isVerified: true)
    static let userViewModel = ModelUserViewModel(user: userModel)
    static let placeRoom =  PlaceRoom(users: [UserPreviewModel(id: 1, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 2, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 3, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen",age: 22, online: true),
                                              UserPreviewModel(id: 4, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 5, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 6, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 7, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 8, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 9, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 10, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true),
                                              UserPreviewModel(id: 11, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, online: true)], count: 12, place: "EVN")
    
    static let swipeUser = SwipeUserModel(id: 1, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, interests: [UserInterestModel(same: false, name: "Travel"), UserInterestModel(same: false, name: "Coffee"), UserInterestModel(same: true, name: "Entertain"), UserInterestModel(same: true, name: "Entertainment"), UserInterestModel(same: false, name: "Training"), UserInterestModel(same: false, name: "Coffee"), UserInterestModel(same: true, name: "Entertain")], online: true, isVerified: true)
    static let swipeUserViewModel = SwipeUserViewModel(user: swipeUser)
    static let favouritesListModel = FavouritesListModel(favourites: placeRoom.users)
    static let friendRequestModel = FriendRequestModel(id: 1, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", name: "Karen", age: 22, school: "RAU", location: "Yerevan, Armenia", message: "Привет! Буду рада познакомиться")
    static let profile = ProfileModel(id: 1, name: "Karen", age: 22, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", bio: "Ищу компанию на вечер", interests: "", filled: 50, isVerified: false)
}
