//
//  ProfileModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import Foundation
struct ProfileModel: Codable {
    var id: Int
    var name: String
    var age: Int
    var image: String
    var bio: String
    var interests: String
    var filled: Int
    var isVerified: Bool
}

//{
//  "id": 0,
//  "name": "string",
//  "age": 0,
//  "image": "string",
//  "bio": "string",
//  "interests": "string",
//  "filled": 0,
//  "isVerified": true
//}
