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
    var interests: [String]
    var filled: Int
    var isVerified: Bool
}
