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
    static let profile = ProfileModel(id: 1, name: "Karen", age: 22, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", bio: "Ищу компанию на вечер", interests: ["Coffee"], filled: 50, isVerified: false)
    static let fields = ProfileEditFields(name: "KarenMirakyan", bio: "IOS Developer with over 2 years of experience", occupation: OccupationModel(job: "Barista", company: "CoffeeShop"), school: "", gender: "Мужчина", city: "Yerevan", showGender: true, interests: ["Coffee"], isVerified: true, age: 22)
    static let profileImages = ProfileImageList(images: [ProfileImageModel(id: 1, type: "avatar", image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg"),
                                                         ProfileImageModel(id: 2, type: "", image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg")])
    static let interlocutors = [InterlocutorsViewModel(model: InterlocutorsModel(id: 1, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: true, isRead: true, chat: 1, name: "Anna")),
                                InterlocutorsViewModel(model: InterlocutorsModel(id: 2, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: true, isRead: true, chat: 1, name: "Karen")),
                                InterlocutorsViewModel(model: InterlocutorsModel(id: 3, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: false, isRead: false, chat: 1, name: "Martin")),
                                InterlocutorsViewModel(model: InterlocutorsModel(id: 4, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: true, isRead: false, chat: 1, name: "Hunt Lounge Bar")),
                                InterlocutorsViewModel(model: InterlocutorsModel(id: 5, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: false, isRead: true, chat: 1, name: "Hrach")),
                                InterlocutorsViewModel(model: InterlocutorsModel(id: 6, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: true, isRead: false, chat: 1, name: "John"))]
    
    static let chats = [ChatModelViewModel(chat: ChatModel(id: 1,
                                                           name: "Anna",
                                                           image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg",
                                                           online: true,
                                                           isGroup: false,
                                                           message: MessagePreviewModel(id: 1,
                                                                                        message: "Hello World",
                                                                                        type: "text",
                                                                                        createdAt: "2022-04-22 21:47:38.123",
                                                                                        status: "sent",
                                                                                        sender: SenderModel(id: 1, name: "Karen")),
                                                           isMuted: false)),
                        ChatModelViewModel(chat: ChatModel(id: 2,
                                                           name: "Евгений",
                                                           image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg",
                                                           online: true,
                                                           isGroup: false,
                                                           message: MessagePreviewModel(id: 1,
                                                                                        message: "Оки, тогда до встречи)",
                                                                                        type: "text",
                                                                                        createdAt: "2022-04-22 21:47:38.123",
                                                                                        status: "sent",
                                                                                        sender: SenderModel(id: 2, name: "Anna")),
                                                           isMuted: false)),
                        ChatModelViewModel(chat: ChatModel(id: 3,
                                                           name: "Hunt Lounge Bar",
                                                           image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg",
                                                           online: true,
                                                           isGroup: true,
                                                           message: MessagePreviewModel(id: 1,
                                                                                        message: "Окей) Ну будем тебя тогда ждать!",
                                                                                        type: "text",
                                                                                        createdAt: "2022-04-22 21:47:38.123",
                                                                                        status: "read",
                                                                                        sender: SenderModel(id: 3, name: "Анна")),
                                                           isMuted: false)),
                        ChatModelViewModel(chat: ChatModel(id: 4,
                                                           name: "Anna",
                                                           image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg",
                                                           online: true,
                                                           isGroup: false,
                                                           message: MessagePreviewModel(id: 1,
                                                                                        message: "Hello World",
                                                                                        type: "text",
                                                                                        createdAt: "2022-04-22 21:47:38.123",
                                                                                        status: "sent",
                                                                                        sender: SenderModel(id: 1, name: "Karen")),
                                                           isMuted: true))]
    
    
    static let chatListModel = ChatListModel(chats: [ChatModel(id: 1,
                                                               name: "Anna",
                                                               image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg",
                                                               online: true,
                                                               isGroup: false,
                                                               message: MessagePreviewModel(id: 1,
                                                                                            message: "Hello World",
                                                                                            type: "text",
                                                                                            createdAt: "2022-04-22 21:47:38.123",
                                                                                            status: "sent",
                                                                                            sender: SenderModel(id: 1, name: "Karen")),
                                                               isMuted: false)])
    
    static let interlocutorsListModel = InterlocutorsListModel(interlocutors: [InterlocutorsModel(id: 1, image: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg", online: true, isRead: true, chat: 1, name: "Hunt Lounge Bar")])
    
}
