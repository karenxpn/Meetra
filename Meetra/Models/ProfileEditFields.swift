//
//  ProfileEditFields.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import Foundation
struct ProfileEditFields: Codable {
    var bio: String
    var job: String
    var gender: String
    var location: String
    var interests: [String]
}
