//
//  AppPreviewModels.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
struct AppPreviewModels {
    static let userModel = UserModel(id: 1, name: "Karen", age: 22, online: true, starred: false, school: "RAU", location: "Yerevan, Armenia", bio: "Люблю плёночные фотики, котиков и фалафель", sameInterests: ["Travel", "aa", "aaa", "aaaaa", "karen", "tr"], userInterests: ["Bar", "Dancing", "sdklfj", "asldk"], images: ["https://sln-storage.s3.us-east-2.amazonaws.com/img/icon/day/150/png/111.png"])
    static let userViewModel = ModelUserViewModel(user: userModel)
    static let placeRoom =  PlaceRoom(users: [UserPreviewModel(id: 1, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 2, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 3, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 4, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 5, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 6, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 7, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 8, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 9, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 10, image: "Karen", name: "Karen", online: true),
                                              UserPreviewModel(id: 11, image: "Karen", name: "Karen", online: true)], count: 12, place: "EVN")
}
