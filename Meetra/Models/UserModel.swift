//
//  UserModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
struct UserModel: Codable, Identifiable {
    var id: Int
    var name: String
    var age: Int
    var online: Bool
    var starred: Bool
    var school: String
    var location: String
    var bio: String
    var interests: [UserInterestModel]
    var images: [String]
}

struct UserInterestModel: Codable {
    var same: Bool
    var name: String
}


struct ModelUserViewModel: Identifiable {
    var user: UserModel
    init(user: UserModel) {
        self.user = user
    }
    
    var id: Int                         { self.user.id }
    var name: String                    { self.user.name }
    var age: Int                        { self.user.age }
    var online: Bool                    { self.user.online }
    var school: String                  { self.user.school }
    var location: String                { self.user.location }
    var bio: String                     { self.user.bio }
    var interests: [UserInterestModel]  { self.user.interests }
    var images: [String]                { self.user.images }
    
    var starred: Bool           {
        get { self.user.starred }
        set { self.user.starred = newValue }
    }
}
