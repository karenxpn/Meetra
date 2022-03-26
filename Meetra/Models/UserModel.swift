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
    var interests: [String]
    var images: [String]
}
