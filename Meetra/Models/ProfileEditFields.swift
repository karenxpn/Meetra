//
//  ProfileEditFields.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import Foundation
struct ProfileEditFields: Codable {
    var name: String
    var bio: String
    var occupation: String
    var school: String
    var gender: String
    var location: String
    var interests: [String]
}
